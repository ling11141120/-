----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_original_user_book_consume_ed
-- workflow_version : 47
-- create_user      : yanxh
-- task_name        : ads_bi_original_book_consume
-- task_version     : 4
-- update_time      : 2023-11-18 09:48:21
-- sql_path         : \starrocks\tbl_ads_bi_original_user_book_consume_ed\ads_bi_original_book_consume
----------------------------------------------------------------
-- SQL语句
delete from  ads.ads_bi_original_book_consume where dt>='${bf_2_dt}';

-- SQL语句
insert into ads.ads_bi_original_book_consume
select  a.dt,a.site_id,a.book_nature,a.money_amount,a.vip_amount,a.gift_amount,a.award_amount,a.total_amount,
        0 as reward_sale, 0 as remuneration_money,now() as etl_time
from
(
select a.dt,a.site_id,b.book_nature,
    sum(case when a.types=1 then a.amount end)/100 as money_amount,
  sum(case when a.types=4 then a.amount end)/100 as vip_amount,
     sum(case when a.types=2 then a.amount end)/100 as gift_amount,
   sum(case when a.types=3 then a.amount end)/100 as award_amount,
      sum(case when a.types=5 then a.amount end)/100 as total_amount
from dws.dws_consume_user_consume_ed  a
inner join
(
select book_id,book_nature from dim.dim_shuangwen_book_read_consume_info  b  where product_id in  (3311,3322,3366,3371,3388,3501,3511) and book_nature in (3,5) ) b
on a.book_id=b.book_id
where
 a.product_id in (3311,3322,3366,3371,3388,3501,3511)
and a.dt>='${bf_2_dt}'
and a.dt<'${dt}'
GROUP BY 1,2,3
)  a ;
