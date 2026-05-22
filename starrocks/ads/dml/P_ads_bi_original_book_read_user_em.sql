----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_original_user_book_consume_ed
-- workflow_version : 47
-- create_user      : yanxh
-- task_name        : ads_bi_original_book_read_user_em
-- task_version     : 4
-- update_time      : 2023-11-18 09:48:21
-- sql_path         : \starrocks\tbl_ads_bi_original_user_book_consume_ed\ads_bi_original_book_read_user_em
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_original_book_read_user_em
select   year(a.dt) years,
1 as  qtypes,
      DATE_FORMAT(a.dt, '%c') as dt,
      a.site_id,
       a.book_id,
       a.user_id,
       count(1) counts,now() as etl_time
from
dws.dws_read_user_readbook_ed   a
inner join
(
select book_id,book_nature from dim.dim_shuangwen_book_read_consume_info  b  where product_id in  (3311,3322,3366,3371,3388,3501,3511) and book_nature in (3,5) ) b
on a.book_id=b.book_id
where
a.product_id in (3311,3322,3366,3371,3388,3501,3511)
and a.dt>=date_sub(DATE_FORMAT(DATE_SUB(NOW(), INTERVAL DAYOFMONTH(NOW())-1 DAY), '%Y-%m-%d'),interval 1 month)
and a.dt <'${dt}'
group by 1,2,3,4,5 ,6 ;
