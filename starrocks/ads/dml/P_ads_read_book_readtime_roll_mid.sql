----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_book_read_consume_info_a
-- workflow_version : 12
-- create_user      : linq
-- task_name        : ads_read_book_readtime_roll_mid
-- task_version     : 8
-- update_time      : 2023-12-23 13:46:58
-- sql_path         : \starrocks\tbl_ads_wide_book_read_consume_info_a\ads_read_book_readtime_roll_mid
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_read_book_readtime_roll_mid where dt='${bf_15_dt}';

-- SQL语句
insert into ads.ads_read_book_readtime_roll_mid
select dt,book_id,sum(read_day_td) as read_day_td,sum(read_time_td) as read_time_td,now() as etl_time
from(
    select '${bf_15_dt}' as dt,book_id,read_day_td,read_time_td
    from ads.ads_read_book_readtime_roll_mid
    where dt='${bf_16_dt}'
    union all
    select dt,book_id ,1 as read_day_td,sum(read_times) as read_time
    from dws.dws_read_user_book_readtime_ed
    where dt='${bf_15_dt}' and product_id !=-1
    group by 1,2,3
)t1
group by 1,2;
