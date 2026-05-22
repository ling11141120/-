----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_cost_income
-- workflow_version : 8
-- create_user      : zhengtt
-- task_name        : ads_report_cost_income
-- task_version     : 8
-- update_time      : 2025-09-28 17:41:39
-- sql_path         : \starrocks\tbl_ads_report_cost_income\ads_report_cost_income
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_cost_income where product_id = 0 and dt = '${dt}';

-- SQL语句
insert into ads.ads_report_cost_income
select 	'${dt}' as dates,ifnull(a.product_id,0) as product_id,a.book_id,a.book_name,a.origin_bookname,a.object_bookname,
          a.Promotion_status,a.object_book_type,a.is_cost_rate,a.cost_amt_7,c.amount_7,a.cost_amt_30,c.amount_30,
          a.cost_amt_curmon,c.amount_curmon,a.cost_amt_YTD,c.amount_YTD,now() as etl_time
from(
        select 	a.product_id as product_id,a.book_id as  book_id,a.book_name as book_name,a.origin_bookname as  origin_bookname,
                  a.object_bookname as object_bookname,a.Promotion_status as Promotion_status,a.object_book_type as object_book_type,
                  a.is_cost_rate as is_cost_rate,b.cost_amt_7 as cost_amt_7,
                  b.cost_amt_30 as cost_amt_30,b.cost_amt_curmon as  cost_amt_curmon,b.cost_amt_YTD as cost_amt_YTD
        from
            (
                select (case when site_id=322 then 3366
                             when site_id=375 then 3388
                             when site_id=410 then 3311
                             when site_id=418 then 3371
                             when site_id=409 then 3322
                             when site_id=419 then 3399
                             when site_id=412 then 3561
                             when site_id=413 then 3571
                             when site_id=414 then 3501
                             when site_id=415 then 3581
                             when site_id=433 then 3511
                             when site_id=435 then 3521
                             when site_id=436 then 3531
                             when site_id=445 then 3541
                             when site_id=497 then 3621
                    end
                           )as product_id,
                       book_id,cname as book_name,from_book_Name as origin_bookname,to_book_name as object_bookname,Promotion_tp as Promotion_status,object_book_type,is_cost_rate
                from dim.dim_language_book_promotion_info_snap
                where dt = '${bf_1_dt}'
            )a
                left join
            (
                select 	s1.product_id,s1.book_id,
                          sum(case when dt>= '${bf_7_dt}'  then cost_amt_all end) as cost_amt_7,
                          sum(case when dt>= '${bf_30_dt}' then cost_amt_all end) as cost_amt_30,
                          sum(case when date_format(dt,'%Y-%m') = date_format('${bf_1_dt}','%Y-%m') then cost_amt_all end) as cost_amt_curmon,
                          sum(cost_amt_all) as cost_amt_YTD
                from (
                         select dt,product_id,book_id,sum(cost_amt) as cost_amt_all
                         from dws.dws_content_translate_remuneration_ed where dt >= '2021-01-01' and dt < '${dt}'
                         group by 1,2,3
                     )s1
                group by 1,2
            )b
            on a.product_id=b.product_id and a.book_id = b.book_id
    )a
        left join
    (
        select 	book_id,
                  sum(case when dt>= '${bf_7_dt}' and dt< '${dt}' then amount end)/100*6.5 as amount_7,
                  sum(case when dt>= '${bf_30_dt}' and dt< '${dt}' then amount end)/100*6.5 as amount_30,
                  sum(case when date_format(dt,'%Y-%m') = date_format('${bf_1_dt}','%Y-%m') and dt< '${dt}' then amount end)/100*6.5 as amount_curmon,
                  sum(amount)/100*6.5 as amount_YTD
        from dws.dws_consume_user_consume_ed
        where dt >='2021-01-01' and dt < '${dt}'
          and book_id in (select  distinct  book_id from dim.dim_language_book_promotion_info_snap where dt = '${bf_1_dt}')
          and  types in (1)
        group by 1
    )c
    on a.book_id = c.book_id;
