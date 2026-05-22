----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_book_capacity_rate_stat
-- workflow_version : 11
-- create_user      : zhengtt
-- task_name        : ads_report_book_capacity_rate_stat
-- task_version     : 11
-- update_time      : 2026-04-07 20:17:34
-- sql_path         : \starrocks\tbl_ads_report_book_capacity_rate_stat\ads_report_book_capacity_rate_stat
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_book_capacity_rate_stat
with rem1  as(
    select 	'${bf_1_dt}' as dt,book_id,role_type,sum(font_length) as font_length_total,
              sum(case when date_format(dt,'%Y-%m') = date_format('${bf_1_dt}','%Y-%m') then font_length end) as font_length_curmonth
    from dwd.dwd_content_translate_remuneration
    where remuneration_type = 1 and book_id > 0 and dt < '${dt}'
    group by 1,2,3
)
select 	'${dt}' as dt,a.tolanguage as site_id,a.book_id,a.BookCode,a.frombookname,REPLACE(a.tobookname,"'","\'") as to_book_name,a.object_book_type,
          b.PublishLength,b.avg_chapter_length,b.daily_number,b.ProofreadLength,a.left_Number/b.daily_number as update_day_left,
          a.EditPublishNumber,a.left_Number,c.cn_chapter_publish,c.cn_font_length,a.InterpreterNumber,a.ForeignNumber,a.ProofreadNumber,
          c.cn_chapter_publish-a.ProofreadNumber as translate_left,a.InterpreterNumber-a.ForeignNumber as foreign_left,
          a.ForeignNumber-a.ProofreadNumber as proofread_left,a.Remark,d.proofread_font_length_curmonth,
          d.interpreter_font_length,d.foreign_font_length,d.proofread_font_length,e.w3_reach_dt,e.w5_reach_dt,e.w10_reach_dt,e.w15_reach_dt,e.w20_reach_dt,e.w25_reach_dt,e.w30_reach_dt,e.w35_reach_dt,
          f.font_inc_day,f.font_inc_week,g.build_time,g.publish_days,h.first_translate_day,h.to_firstday_num,
          i.cost_back_dt,j.cost_amt_7,j.amount_7,j.cost_amt_7/j.amount_7 as cost_back_rate_7,
          j.cost_amt_curmon,j.amount_curmon,j.cost_amt_curmon/j.amount_curmon as cost_back_rate_curmon,
          j.amount_curmon_sort_order,amount_YTD_sort_order ,now() as etl_time
from
    (	select 	tolanguage,tobookid*1000+tolanguage as book_id,BookCode,frombookname,tobookname,ObjectBookType as object_book_type,PublishLength,
                   EditPublishNumber ,InterpreterNumber ,ForeignNumber ,ProofreadNumber ,Remark,
                   ProofreadNumber - EditPublishNumber as left_Number,
                   InterpreterNumber - ForeignNumber as Interpreter_left_Number,
                   ForeignNumber - ProofreadNumber as Foreign_left_Number
         from ods.ods_edit_book_LanguageBookTotal
         where StatisticsDate = '${bf_1_dt}' and  (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end)
    )a left join
    (	select 	dt,ToLanguage,ToBookId*1000+ToLanguage as book_id,PublishLength / PublishNumber  as avg_chapter_length,
                   (StartNum+StartPlusNum/7) as daily_number,ProofreadLength,PublishLength
         from ods.ods_tidb_shuangwen_en_bookcapacitymonitoring
         where dt = '${bf_1_dt}'
    )b on a.book_id = b.book_id
       left join
    (	SELECT 	b.SwBookId*1000+b.ToLanguage as book_id,a.cn_chapter_publish as cn_chapter_publish,a.cn_font_length as cn_font_length
         FROM
             (
                 select a.id as bookid,count(DISTINCT b.id) as cn_chapter_publish,sum(b.FontLength) as cn_font_length
                 from ods.ods_tidb_shuangwen_en_custombook a
                          left join ods.ods_tidb_shuangwen_en_customchapter b
                                    on a.id = b.bookid
                 where b.status = 1 and b.delstatus = 0
                 group by 1
             )a
                 left join
             (
                 select bookid,SwBookId,ToLanguage
                 from ods.ods_tidb_shuangwen_en_objectbook
                 where IsCustom = 1 and FromLanguage = 0
             )b
             on a.bookid = b.bookid
         where b.SwBookId is not null
         union all
         select b.SwBookId*1000+b.ToLanguage as book_id,a.cn_chapter_publish as cn_chapter_publish,a.cn_font_length as cn_font_length
         from
             (
                 select BookID as bookid,normalchapternum_f as cn_chapter_publish,`Length` as cn_font_length
                 from ods.ods_book_novel_book_m where productid = 8858
             )a
                 left join
             (
                 select bookid,SwBookId,ToLanguage
                 from ods.ods_tidb_shuangwen_en_objectbook
                 where IsCustom = 0 and FromLanguage = 0
             )b
             on a.bookid = b.bookid
         where b.SwBookId is not null
    )c on a.book_id = c.book_id
       left join
    (	select 	dt,book_id,
                   max(case when role_type = 3 then font_length_curmonth
                            else 0
                       end ) as proofread_font_length_curmonth,
                   max(case when role_type = 1 then font_length_total
                            else 0
                       end ) as interpreter_font_length,
                   max(case when role_type = 2 then font_length_total
                            else 0
                       end ) as foreign_font_length,
                   max(case when role_type = 3 then font_length_total
                            else 0
                       end ) as proofread_font_length
         from rem1
         group by dt,book_id
    )d on a.book_id = d.book_id
       left JOIN
    (	select 	b.ToLanguage as ToLanguage,b.book_id as book_id,
                   max(case when b.is_3w_reach = 'a' then b.dt else null end) w3_reach_dt,
                   max(case when b.is_5w_reach = 'a' then b.dt else null end) w5_reach_dt,
                   max(case when b.is_10w_reach = 'a' then b.dt else null end) w10_reach_dt,
                   max(case when b.is_15w_reach = 'a' then b.dt else null end) w15_reach_dt,
                   max(case when b.is_20w_reach = 'a' then b.dt else null end) w20_reach_dt,
                   max(case when b.is_25w_reach = 'a' then b.dt else null end) w25_reach_dt,
                   max(case when b.is_30w_reach = 'a' then b.dt else null end) w30_reach_dt,
                   max(case when b.is_35w_reach = 'a' then b.dt else null end) w35_reach_dt
         from
             (
                 select 	a.dt as dt,a.ToLanguage as ToLanguage,a.book_id as book_id,PublishLength,PublishLength2,
                           case 	when PublishLength >= 30000 and PublishLength2 <30000 and PublishLength2 > 0  then 'a'
                                   when PublishLength = 30000 and PublishLength2 = 0 then 'a'
                                   when PublishLength > 30000 and PublishLength2 = 0 then 'c'
                                   else 'b' end is_3w_reach,
                           case 	when PublishLength >= 50000 and PublishLength2 <50000 and PublishLength2 > 0  then 'a'
                                   when PublishLength = 50000 and PublishLength2 = 0 then 'a'
                                   when PublishLength > 50000 and PublishLength2 = 0 then 'c'
                                   else 'b' end is_5w_reach,
                           case 	when PublishLength >= 100000 and PublishLength2 <100000 and PublishLength2 > 0  then 'a'
                                   when PublishLength = 100000 and PublishLength2 = 0 then 'a'
                                   when PublishLength > 100000 and PublishLength2 = 0 then 'c'
                                   else 'b' end is_10w_reach,
                           case 	when PublishLength >= 150000 and PublishLength2 <150000 and PublishLength2 > 0  then 'a'
                                   when PublishLength = 150000 and PublishLength2 = 0 then 'a'
                                   when PublishLength > 150000 and PublishLength2 = 0 then 'c'
                                   else 'b' end is_15w_reach,
                           case 	when PublishLength >= 200000 and PublishLength2 <200000 and PublishLength2 > 0  then 'a'
                                   when PublishLength = 200000 and PublishLength2 = 0 then 'a'
                                   when PublishLength > 200000 and PublishLength2 = 0 then 'c'
                                   else 'b' end is_20w_reach,
                           case 	when PublishLength >= 250000 and PublishLength2 <250000 and PublishLength2 > 0  then 'a'
                                   when PublishLength = 250000 and PublishLength2 = 0 then 'a'
                                   when PublishLength > 250000 and PublishLength2 = 0 then 'c'
                                   else 'b' end is_25w_reach,
                           case 	when PublishLength >= 300000 and PublishLength2 <300000 and PublishLength2 > 0 then 'a'
                                   when PublishLength = 300000 and PublishLength2 = 0 then 'a'
                                   when PublishLength > 300000 and PublishLength2 = 0 then 'c'
                                   else 'b' end is_30w_reach,
                           case 	when PublishLength >= 350000 and PublishLength2 <350000 and PublishLength2 > 0 then 'a'
                                   when PublishLength = 350000 and PublishLength2 = 0 then 'a'
                                   when PublishLength > 350000 and PublishLength2 = 0 then 'c'
                                   else 'b' end is_35w_reach
                 from
                     (
                         select 	t.dt as dt,t.ToLanguage as ToLanguage,t.ToBookId*1000+t.ToLanguage as book_id,t.PublishLength as PublishLength,
                                   lag(t.PublishLength,1,0) over(partition by (t.ToBookId*1000+t.ToLanguage) order by dt) as PublishLength2
                         from
                             (
                                 select dt,ToBookId,ToLanguage,PublishLength,
                                        row_number() over(partition by dt,ToBookId,ToLanguage order by id desc) as rn
                                 from  ods.ods_tidb_shuangwen_en_bookcapacitymonitoring
                             )t
                         where t.rn = 1
                     )a
             )b
         group by b.ToLanguage,b.book_id
    )e	on a.book_id = e.book_id
       left join
    (	select 	'${bf_1_dt}' as dt,
                   a.book_id  as book_id,
                   a.font_length_day1 - a.font_length_day2 as font_inc_day,
                   a.font_length_week1 - a.font_length_week2 as font_inc_week
         from
             (
                 select 	book_id,
                           sum(if(dt >= '${bf_1_dt}',font_length,0)) as font_length_day1,
                           sum(if(dt < '${bf_1_dt}' and dt >= '${bf_2_dt}',font_length,0)) as font_length_day2,
                           sum(if(dt >= '${bf_7_dt}',font_length,0)) as font_length_week1,
                           sum(if(dt < '${bf_7_dt}' and dt >= DATE_SUB('${dt}',INTERVAL 14 day),font_length,0)) as font_length_week2
                 from dwd.dwd_content_translate_remuneration
                 where remuneration_type = 1 and book_id > 0 and dt < '${dt}' and dt >= DATE_SUB('${dt}',INTERVAL 14 day) and role_type = 3
                 group by 1
             )a
    )f on a.book_id = f.book_id
       left JOIN
    (	select book_id ,build_time,DATEDIFF('${bf_1_dt}',date(build_time)) as publish_days
         from dim.dim_shuangwen_book_read_consume_info
    )g on a.book_id = g.book_id
       left JOIN
    (	select  a.book_id as book_id,a.dt as first_translate_day,DATEDIFF('${bf_1_dt}',a.dt) as  to_firstday_num
         from
             (
                 select book_id ,dt,row_number() over(partition by book_id order by dt) as rn
                 from dwd.dwd_content_translate_remuneration where remuneration_type = 1 and book_id > 0
             )a
         where a.rn = 1
    )h on a.book_id = h.book_id
       left join
    (	select a.book_id as book_id ,min(a.cost_back_dt) as cost_back_dt
         FROM
             (
                 select dt,book_id ,case when cost_amt_YTD/amount_YTD < 1 then date_sub(dt,interval 1 day) else null end cost_back_dt
                 from ads.ads_report_cost_income
             )a
         where a.cost_back_dt is not null
         group by a.book_id
    )i	on a.book_id = i.book_id
       left join
    (		select 	a.site_id as site_id,a.book_id as book_id,a.cost_amt_7  as cost_amt_7 ,
                       a.amount_7 as amount_7,a.cost_amt_curmon as cost_amt_curmon,
                       a.amount_curmon as amount_curmon,
                       concat(cast(if(a.amount_curmon is not null and a.amount_curmon != 0,a.amount_curmon_sort,'-') as string),'/',cast(if(a.amount_curmon is not null and a.amount_curmon != 0,a.site_book_num_curmon,'-') as string)) as amount_curmon_sort_order,
                       concat(cast(if(a.amount_YTD is not null and a.amount_YTD != 0,a.amount_YTD_sort,'-') as string),'/',cast(if(a.amount_YTD is not null and a.amount_YTD != 0,a.site_book_num_YTD,'-') as string)) as amount_YTD_sort_order
             FROM
                 (
                     select 	book_id%1000 as site_id,book_id,cost_amt_7 ,amount_7 ,cost_amt_curmon ,amount_curmon,amount_YTD,
			row_number() over(partition by (book_id%1000) order by amount_curmon desc) as amount_curmon_sort,
			row_number() over(partition by (book_id%1000) order by amount_YTD desc) as amount_YTD_sort,
			sum(if(amount_curmon is not null and amount_curmon != 0 ,1,0)) over(partition by (book_id%1000)) as site_book_num_curmon,
			sum(if(amount_YTD  is not null and amount_YTD != 0 ,1,0)) over(partition by (book_id%1000)) as site_book_num_YTD
                     from ads.ads_report_cost_income
                     where dt = '${dt}'
                 )a
    )j on a.book_id = j.book_id;
