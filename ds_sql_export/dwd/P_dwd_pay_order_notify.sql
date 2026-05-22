----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_pay_order_notify
-- workflow_version : 10
-- create_user      : hufengju
-- task_name        : dwd_pay_order_notify
-- task_version     : 10
-- update_time      : 2025-07-05 10:41:43
-- sql_path         : \starrocks\tbl_dwd_pay_order_notify\dwd_pay_order_notify
----------------------------------------------------------------
-- SQL语句
insert into dwd.`dwd_pay_order_notify`
select
	date(a.CreateTime) as dt
	,a.ProductId as product_id
	,b.OrderSerialId as order_id
	,a.CreateTime as cancel_time
	,b.CreateTime as create_time
	,a.UserId  as user_id
	,a.Sku as sku
	,a.CooOrderId as coo_order_id
	,a.PackageId  as package_id
	,a.PayType as pay_type
	,a.FirstSubOrderSerialId  as first_sub_order_serial_id
	,if(a.CreateTime < '2025-02-12', 3,
        if(a.PayType = 'appstore',
            case when a.NotifyType like '%AUTO_RENEW_DISABLED%' then 3
                when a.NotifyType like '%AUTO_RENEW_ENABLED%' then 1
                when a.NotifyType like '%CANCELLED%' or a.NotifyType = 'CANCEL' or a.NotifyType like '%canceled%' then 3
                else a.NotifyType
            end,
            case when a.NotifyType in(3, 10, 12, 13, 20) then 3
                when a.NotifyType in(1, 2, 4, 7, 9, 11) then 1
                when a.NotifyType like '%CANCELLED%' or a.NotifyType = 'CANCEL' or a.NotifyType like '%canceled%' then 3
                else a.NotifyType
            end
        )
	) as notify_type
	,b.Amount/100 as amount
	,b.BaseAmount/100 as base_amount
	,b.OrderStatus as order_status
	,b.ShopItemId as shop_item_id
	,now() as elt_tm
from ods.ods_tidb_sharpengine_pay_PayOrderNotify a
inner join ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di b  on a.OrderId=b.OrderId
--inner join ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di b  on  a.CooOrderId=b.CooOrderId
where 1=1
and a.CreateTime >='${bf_1_dt}' and  date(a.CreateTime)<='${dt}'
and a.OrderType=1;
