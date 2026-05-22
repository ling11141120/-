----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_translate_cost
-- workflow_version : 5
-- create_user      : zhugl
-- task_name        : tbl_ads_report_translate_cost
-- task_version     : 4
-- update_time      : 2024-10-30 14:21:16
-- sql_path         : \starrocks\tbl_ads_report_translate_cost\tbl_ads_report_translate_cost
----------------------------------------------------------------
-- SQL语句
insert into  ads.ads_report_translate_cost
with remuneration as(
	select
		to_language,
			sum(if(dt >= DATE_SUB('${dt}', INTERVAL 1 day) and  role_type =3, font_length, 0)) as font_length_day13,
			sum(if(dt < DATE_SUB('${dt}', INTERVAL 1 day) and dt >= DATE_SUB('${dt}', INTERVAL 2 day) and role_type =3 , font_length, 0)) as font_length_day23,
			sum(if(dt >= DATE_SUB('${dt}', INTERVAL 7 day) and role_type =3 , font_length, 0)) as font_length_week13,
			sum(if(dt < DATE_SUB('${dt}', INTERVAL 7 day) and dt >= DATE_SUB('${dt}', INTERVAL 14 day) and role_type =3 , font_length, 0)) as font_length_week23,
			sum(if(SUBSTR(dt, 1, 7) = SUBSTR(DATE_SUB('${dt}', INTERVAL 1 day), 1, 7)and  role_type =3 , font_length, 0)) font_length_month_sum3,  -- -----
			count(DISTINCT  if(SUBSTR(dt, 1, 7) = SUBSTR(DATE_SUB('${dt}', INTERVAL 1 day), 1, 7) , book_id, null)) translate_book_1d_cnt , -- zaifanyi
			-- --
			sum(if(dt >= DATE_SUB('${dt}', INTERVAL 1 day) and  role_type =2, font_length, 0)) as font_length_day12,
			sum(if(dt < DATE_SUB('${dt}', INTERVAL 1 day) and dt >= DATE_SUB('${dt}', INTERVAL 2 day)and  role_type =2 , font_length, 0)) as font_length_day22,
			sum(if(dt >= DATE_SUB('${dt}', INTERVAL 7 day) and role_type =2 , font_length, 0)) as font_length_week12,
			sum(if(dt < DATE_SUB('${dt}', INTERVAL 7 day) and dt >= DATE_SUB('${dt}', INTERVAL 14 day)and  role_type =2 , font_length, 0)) as font_length_week22,
			sum(if(SUBSTR(dt, 1, 7) = SUBSTR(DATE_SUB('${dt}', INTERVAL 1 day), 1, 7) and role_type =2 , font_length, 0)) font_length_month_sum2,  -- -----
			-- --
			sum(if(dt >= DATE_SUB('${dt}', INTERVAL 1 day) and  role_type =1, font_length, 0)) as font_length_day11,
			sum(if(dt < DATE_SUB('${dt}', INTERVAL 1 day) and dt >= DATE_SUB('${dt}', INTERVAL 2 day) and role_type =1 , font_length, 0)) as font_length_day21,
			sum(if(dt >= DATE_SUB('${dt}', INTERVAL 7 day) and role_type =1 , font_length, 0)) as font_length_week11,
			sum(if(dt < DATE_SUB('${dt}', INTERVAL 7 day) and dt >= DATE_SUB('${dt}', INTERVAL 14 day) and role_type =1 , font_length, 0)) as font_length_week21,
			sum(if(SUBSTR(dt, 1, 7) = SUBSTR(DATE_SUB('${dt}', INTERVAL 1 day), 1, 7)and  role_type =1 , font_length, 0)) font_length_month_sum1  -- ----
	from
		dwd.dwd_content_translate_remuneration
	where
		remuneration_type = 1
		and book_id > 0
		and dt < '${dt}'
	 	and dt >= DATE_SUB('${dt}', INTERVAL 32 day )
        and st NOT in (3, 5, 7)
		and role_type in(1,2,3) -- 1 -- 2 --  3 --
  		and Object_Book_Type !=1
	group by 1
),
 cost as(
select mod(a.book_id,1000) language_id,
 sum(cost_flag) cost_flag_cnt  , -- ---
 sum(amount_flag)amount_flag_cnt, -- ---
 sum(if (cost_amt_YTD>0,1,0)) cost_book_a_cnt , -- -----
 sum(if (cost_amt_curmon>0,1,0)) cost_book_curmon_cnt , -- -------
 sum(if (amount_curmon>=cost_amt_curmon,1,0)) amount_book_curmon_cnt , -- -------
 sum(if(b.book_id is not   null and cost_amt_YTD>amount_YTD,1,0 ))cost_flag_90_cnt,   -- ----90----
 sum(amount_curmon)amount_curmon,  -- ----
 sum(cost_amt_curmon)cost_amt_curmon -- ----
from (select book_id,cost_amt_YTD,amount_YTD,if(cost_amt_YTD>amount_YTD,1,0) cost_flag,if(cost_amt_YTD<=amount_YTD,1,0)amount_flag,
  		cost_amt_curmon,amount_curmon
		from  ads.ads_report_cost_income where dt = DATE_SUB('${dt}', INTERVAL 1 day) and object_book_type =0 )a
		left  join (
		select book_id ,DATEDIFF( DATE_SUB('${dt}', INTERVAL 1 day), first_translate_time)from(
		select book_id ,min(remuneration_time) first_translate_time from
		dwd.dwd_content_translate_remuneration  where Object_Book_Type !=1  group by book_id)a where DATEDIFF( DATE_SUB('${dt}', INTERVAL 1 day), first_translate_time)>=90
		)b
		on a.book_id = b.book_id  group by mod(a.book_id,1000)

),
err as (
select
		to_language,
		sum(if(dt = DATE_SUB('${dt}', INTERVAL 1 day ) , if( day_chapter_num>0 and   publishing_cnt/day_chapter_num  <15, 1, if( publishing_cnt/Week_chapter_num <3,1,0) ), 0)) err_chapter_cnt,
		count(DISTINCT if(app_publish_cnt>0 , to_book_id , null ) )app_publish_month_cnt
from
		(select  * from (select a.*,b.ObjectBookType  from 	dwd.dwd_edit_book_languagebooktotal_da a left join
	 (select  productid ,SwBookId ,ToLanguage,max(ObjectBookType)ObjectBookType,max(IsCostRate)IsCostRate  from ods.ods_tidb_shuangwen_en_objectbook group by 1,2,3
) as b on a.to_book_id   = concat(b.SwBookId, b.ToLanguage)
	)a where ObjectBookType=0)a
left join (
	select
		ToLanguage,
		ToBookId * 1000 + ToLanguage as book_id,
		if(StartNum != 0 , StartNum + StartPlusNum / 7 , 0 ) as day_chapter_num,
		if(StartNum = 0 and StartPlusNum>0 , StartPlusNum, 0) Week_chapter_num
	from
			(select  * from (select a.*,b.ObjectBookType  from 	ods.ods_tidb_shuangwen_en_bookcapacitymonitoring a left join
	 (select  productid ,SwBookId ,ToLanguage,max(ObjectBookType)ObjectBookType,max(IsCostRate)IsCostRate  from ods.ods_tidb_shuangwen_en_objectbook group by 1,2,3
) as b on a.tobookid   = b.SwBookId and a.tolanguage = b.ToLanguage
	)a where ObjectBookType=0)a
	where
		dt = DATE_SUB('${dt}', INTERVAL 1 day)
		and (StartNum != 0
			or StartPlusNum != 0)
		) b on a.to_book_id  = b.book_id
where
		substr(dt, 1, 7 ) = substr(DATE_SUB('${dt}', INTERVAL 1 day ), 1, 7) and  dt<=DATE_SUB('${dt}', INTERVAL 1 day )
group by
	1
)
select
		DATE_SUB('${dt}', INTERVAL 1 day) as dt,
		remuneration.to_language,
		remuneration.font_length_day11 - remuneration.font_length_day21 as font_inc_day1,	  -- ---
		remuneration.font_length_week11 - remuneration.font_length_week21 as font_inc_week1, -- ---
		remuneration.font_length_month_sum1, -- ---
		remuneration.font_length_day12 - remuneration.font_length_day22 as font_inc_day2,	  -- ---
		remuneration.font_length_week12 - remuneration.font_length_week22 as font_inc_week2, -- ---
		remuneration.font_length_month_sum2, -- ---
		remuneration.font_length_day13 - remuneration.font_length_day23 as font_inc_day3,	  -- ---
		remuneration.font_length_week13 - remuneration.font_length_week21 as font_inc_week3, -- ---
		remuneration.font_length_month_sum3, -- ---
		err.app_publish_month_cnt ,  -- ------- -----
		remuneration.translate_book_1d_cnt, -- -----
		err.err_chapter_cnt , -- --------- ------=- ----15---------/----<15-=--1--
		cost.cost_book_curmon_cnt,-- ----- -------
		cost.amount_flag_cnt,  --  ---- ----
		amount_book_curmon_cnt, -- -----
		cast(cost.amount_book_curmon_cnt/cost_book_curmon_cnt as decimal(10, 4)) cost_cnt_curmon_rate, -- -----=----/-------
		cast(cost.cost_flag_90_cnt/cost_flag_cnt as decimal(10, 4)) err_cost_amount_rate ,   -- 90----- = --------90--- / -----100%-----
		amount_curmon,-- ----
		cost_amt_curmon,-- ----
		cast(cost_amt_curmon/cost.amount_curmon as decimal(10, 4)) cost_amount_curmon_rate, -- -----
		 now() as etl_time
		from remuneration left join cost on remuneration.to_language = cost.language_id
		left join err on remuneration.to_language = err.to_language;
