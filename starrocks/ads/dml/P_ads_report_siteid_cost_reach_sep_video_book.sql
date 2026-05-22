----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_siteid_cost_reach_sep_video_book
-- workflow_version : 1
-- create_user      : zhengtt
-- task_name        : ads_report_siteid_cost_reach_sep_video_book
-- task_version     : 1
-- update_time      : 2023-11-22 14:41:13
-- sql_path         : \starrocks\tbl_ads_report_siteid_cost_reach_sep_video_book\ads_report_siteid_cost_reach_sep_video_book
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_siteid_cost_reach_sep_video_book
select 	'${dt}' as dt,a.siteid,a.GradeType,b.object_book_type,a.CostRateTarget/100 as CostRateTarget,b.cost_reach_rate,
          a.CostRateTarget/100-b.cost_reach_rate as gap,b.cost_no_reach,b.cost_reach,
          b.total_book_num ,now() as etl_time
from ods.ods_tidb_shuangwen_en_viscgradeconfig a
         left join
     (
         select 	a.site_id as site_id,object_book_type,
                   sum(if(a.cost_amt_curmon < a.amount_curmon,1,0)) as cost_reach,
                   sum(if(a.cost_amt_curmon >= a.amount_curmon,1,0)) as cost_no_reach,
                   count(1) as total_book_num,
                   sum(if(a.cost_amt_curmon < a.amount_curmon,1,0))/count(1) as cost_reach_rate
         from
             (
                 select 	t.site_id as site_id,t.book_id as book_id ,object_book_type,t.cost_amt_curmon as cost_amt_curmon,
                           t.amount_curmon as amount_curmon
                 from (
                          select 	case when product_id  = 3311 then 410
                                         when product_id  = 3322 then 409
                                         when product_id  = 3366 then 322
                                         when product_id  = 3388 then 375
                                         when product_id  = 3399 then 419
                                         when product_id  = 3371 then 418
                                         when product_id  = 3501 then 414
                                         when product_id  = 3511 then 433
                                         when product_id  = 3531 then 436
                                        end site_id,
                                        book_id,
                                        object_book_type,
                                    if(cost_amt_curmon  is null ,0,cost_amt_curmon) as cost_amt_curmon,
                                    if(amount_curmon is null ,0,amount_curmon) as amount_curmon
                          from ads.ads_report_cost_income
                          where  dt = '${dt}'  and  is_cost_rate = 1
                      )t
                 where t.cost_amt_curmon != 0
             )a
         group by 1,2
     )b
     on a.siteid = b.site_id
where date_format('${bf_1_dt}','%Y-%m') = date_format(a.MonthTime,'%Y-%m')
;
