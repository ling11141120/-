----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_sr_pay_order_notify
-- workflow_version : 22
-- create_user      : chenmo
-- task_name        : ads_sr_pay_order_notify_sync
-- task_version     : 7
-- update_time      : 2025-05-24 16:05:42
-- sql_path         : \starrocks\sch_ads_sr_pay_order_notify\ads_sr_pay_order_notify_sync
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sr_pay_order_notify_sync
select
    a.order_id,
    a.create_time,
    a.sku,
    a.package_id,
    a.pay_type,
    a.order_type,
    a.user_id,
    a.product_id,
    a.notify_type,
    now() as etl_time
from ads.ads_sr_pay_order_notify a
where etl_time = (select max(etl_time) from ads.ads_sr_pay_order_notify);
