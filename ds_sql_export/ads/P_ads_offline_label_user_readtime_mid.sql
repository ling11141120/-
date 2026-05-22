----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_user_readtime_mid
-- task_version     : 2
-- update_time      : 2024-10-16 11:25:04
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_user_readtime_mid
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_offline_label_user_readtime_mid
select  '${bf_1_dt}' as dt,product_id,user_id,book_id,sum(read_times) as book_read_times,now() as etl_time
from
(   select product_id,user_id,book_id,book_read_times as read_times
    from ads.ads_offline_label_user_readtime_mid
    where dt = '${bf_2_dt}'
    union all
    select  product_id,user_id,book_id,read_times
    from dws.dws_read_user_book_readtime_ed
    where dt = '${bf_1_dt}' and book_id != 0
    )a
group by 1,2,3,4;
