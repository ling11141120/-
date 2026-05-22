----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_cr_book_sale_di
-- workflow_version : 15
-- create_user      : linq
-- task_name        : ads_cr_book_month_sale_di
-- task_version     : 9
-- update_time      : 2024-09-11 18:11:37
-- sql_path         : \starrocks\tbl_ads_cr_book_sale_di\ads_cr_book_month_sale_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_cr_book_month_sale_di where month_int>=date_format(date_sub(date_trunc('month','${dt}'),interval 1 month),'%Y%m') and month_int<=date_format('${dt}','Y%m');

-- SQL语句
insert into ads.ads_cr_book_month_sale_di
select date_format(dt,'%Y%m') as month_int,
       cn_book_id,
       date_format(dt,'%Y-%m') as month_str,
       cn_book_name,
       cn_book_code,
       partner_name,
       array_join(array_distinct(split(group_concat(to_book_ids),',')),',') as to_book_ids,
       sum(money_amt) as money_amt,
       now() as etl_time
from ads.ads_cr_book_sale_di
where dt>=date_sub(date_trunc('month','${dt}'),interval 1 month) and dt<'${dt}'
group by 1,2,3,4,5,6;
