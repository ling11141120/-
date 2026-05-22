----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_original_user_book_consume_ed
-- workflow_version : 47
-- create_user      : yanxh
-- task_name        : ads_bi_site_id_money_consume
-- task_version     : 3
-- update_time      : 2023-11-18 09:48:21
-- sql_path         : \starrocks\tbl_ads_bi_original_user_book_consume_ed\ads_bi_site_id_money_consume
----------------------------------------------------------------
-- SQL语句
delete from ads.ads_bi_site_id_money_consume  where dt>='${bf_2_dt}';

-- SQL语句
insert into ads.ads_bi_site_id_money_consume
select a.dt,a.site_id,
       sum(a.amount)/100 as money_amount,now() as etl_time
from dws.dws_consume_user_consume_ed a
where
 a.product_id in (3311,3322,3366,3371,3388,3501,3511)
and a.dt>='${bf_2_dt}'
and a.dt<'${dt}'
and a.types=1
GROUP BY 1,2
 ;
