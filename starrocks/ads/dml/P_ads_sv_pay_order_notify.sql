----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_pay_order_notify
-- workflow_version : 19
-- create_user      : chenmo
-- task_name        : ads_sv_pay_order_notify
-- task_version     : 11
-- update_time      : 2026-02-26 09:44:12
-- sql_path         : \starrocks\tbl_ads_sv_pay_order_notify\ads_sv_pay_order_notify
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_pay_order_notify
select
    order_id,
    create_time,
    sku,
    package_id,
    pay_type,
    order_type,
    user_id,
    product_id,
    notify_type,
    now() as etl_time
from (
    select
        order_id,
        create_time,
        row_number() over (partition by order_id order by create_time desc) as rn,
        sku,
        package_id,
        pay_type,
        order_type,
        user_id,
        product_id,
        notify_type
    from (
        select
            FirstSubOrderSerialId as order_id,
            CreateTime as create_time,
            Sku as sku,
            PackageId as package_id,
            PayType as pay_type,
            OrderType as order_type,
            UserId as user_id,
            ProductId as product_id,
            if(CreateTime < '2025-02-12', 3,
                case when NotifyType like '%UserCancelSub%' then 3
                    when lower(PayType) = 'appstore' and NotifyType like '%AUTO_RENEW_DISABLED%' then 3
                    when lower(PayType) = 'appstore' and NotifyType like '%AUTO_RENEW_ENABLED%' then 1
                    when lower(PayType) = 'googleplay' and NotifyType in(3, 10, 12, 13, 20) then 3
                    when lower(PayType) = 'googleplay' and NotifyType in(1, 2, 4, 7, 9, 11) then 1
                    when lower(PayType) = 'paypal' and NotifyType like '%CANCELLED%' then 3
                    when lower(PayType) = 'stripe' and NotifyType like '%canceled%' then 3
                    when lower(PayType) = 'ams' and NotifyType like '%TERMINATED%' then 3
                    when lower(PayType) = 'pagbrasil' and NotifyType like '%Cancelled(3)%' then 3
                    when lower(PayType) = 'dukpay' and NotifyType like '%Cancelled(3)%' then 3
                    when lower(PayType) = 'payermax' and NotifyType like '%SUBSCRIPTION(CANCEL)%' then 3
                    when lower(PayType) = 'payermax' and NotifyType like '%SUBSCRIPTION(TERMINATE)%' then 3
                    when lower(PayType) = 'airwallex' and NotifyType like '%subscription.cancelled%' then 3
                    else NotifyType
                end
            ) as notify_type
        from ods.ods_tidb_sharpengine_pay_PayOrderNotify
        where ProductId = 6833 and CreateTime >= '${bf_1_dt}' and FirstSubOrderSerialId is not null and OrderType = 1
        group by FirstSubOrderSerialId, CreateTime, Sku, PackageId, PayType, OrderType, UserId, ProductId, NotifyType
    ) a where notify_type in(1, 3)
) a where rn = 1;
