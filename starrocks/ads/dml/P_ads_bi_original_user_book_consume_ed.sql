----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_original_user_book_consume_ed
-- workflow_version : 47
-- create_user      : yanxh
-- task_name        : ads_bi_original_user_book_consume_ed
-- task_version     : 4
-- update_time      : 2023-11-18 09:48:21
-- sql_path         : \starrocks\tbl_ads_bi_original_user_book_consume_ed\ads_bi_original_user_book_consume_ed
----------------------------------------------------------------
-- SQL语句
delete from  ads.ads_bi_original_user_book_consume_ed where dt>='${bf_2_dt}';

-- SQL语句
insert into ads.ads_bi_original_user_book_consume_ed
select a.dt,a.site_id,b.book_nature,a.book_id,a.user_id,a.types,sum(a.amount)  amount,now() as etl_time
from dws.dws_consume_user_consume_ed  a
inner join
(
select book_id,book_nature from dim.dim_shuangwen_book_read_consume_info  b  where product_id in  (3311,3322,3366,3371,3388,3501,3511) and book_nature in (3,5) ) b
on a.book_id=b.book_id
where
 a.product_id in (3311,3322,3366,3371,3388,3501,3511)
and a.dt>='${bf_2_dt}'
and a.dt<'${dt}'
 group by 1,2 ,3,4,5,6;
