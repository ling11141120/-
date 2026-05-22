----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_short_video_trade_user_subscribe_di
-- workflow_version : 35
-- create_user      : lxz
-- task_name        : cancel_time
-- task_version     : 27
-- update_time      : 2026-03-04 18:33:03
-- sql_path         : \starrocks\tbl_ads_bi_short_video_trade_user_subscribe_di\cancel_time
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_short_video_trade_user_subscribe_di
select a.dt,
       a.product_id,
       a.id,
       a.order_id,
       a.core,
       a.mt,
       a.current_language2,
       a.country,
       a.user_id,
       a.shop_item,
       a.item_id,
       a.item_count,
       a.vip_type,
       a.sub_pay_type,
       a.charge_type,
       a.price,
       a.first_price,
       a.first_validity,
       a.first_time,
       a.after_charge,
       a.vip_expire_time,
       a.vip_start_time,
       ifnull(b.cancel_time, a.cancel_time) as cancel_time,
       a.subscribe_status,
       a.autoRenew_times,
       a.shop_num,
       a.M0,
       a.M1,
       a.M2,
       a.M3,
       a.M4,
       a.M5,
       a.M6,
       a.M7,
       a.M8,
       a.M9,
       a.M10,
       a.M11,
       a.M12,
       a.etl_time
from ads.ads_bi_short_video_trade_user_subscribe_di a
left join (
    select
        order_id,
        min(dt) as cancel_time
    from ads.ads_srsv_cancel_subscription_order_di_new
    where dt = '${bf_1_dt}'
    group by order_id
) b on a.order_id = b.order_id;
