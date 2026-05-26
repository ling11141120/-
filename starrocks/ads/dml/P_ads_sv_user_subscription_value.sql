----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_short_video_trade_user_subscribe_di
-- workflow_version : 35
-- create_user      : lxz
-- task_name        : ads_sv_user_subscription_value
-- task_version     : 26
-- update_time      : 2025-01-21 19:59:18
-- sql_path         : \starrocks\tbl_ads_bi_short_video_trade_user_subscribe_di\ads_sv_user_subscription_value
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_user_subscription_value
select
    ${bf_1_dt} as dt,
    user_id,
    order_id,
    item_count/(datediff(vip_expire_time, vip_start_time)+1) as value,
    now() as etl_time
from ads.ads_bi_short_video_trade_user_subscribe_di
where vip_start_time <= '${bf_1_dt}' and vip_expire_time >= '${bf_1_dt}';
