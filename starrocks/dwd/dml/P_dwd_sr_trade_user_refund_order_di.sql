----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_dwd_sr_trade_user_refund_order_di
-- workflow_version : 5
-- create_user      : hufengju
-- task_name        : dwd_sr_trade_user_refund_order_di
-- task_version     : 5
-- update_time      : 2025-02-11 11:51:55
-- sql_path         : \starrocks\sch_dwd_sr_trade_user_refund_order_di\dwd_sr_trade_user_refund_order_di
----------------------------------------------------------------
-- 前置SQL语句
delete from dwd.dwd_sr_trade_user_refund_order_di  where dt >= '${bf_1_dt}';

-- SQL语句
-------------------调度 清洗dwd退款订单-------------------------
insert into dwd.dwd_sr_trade_user_refund_order_di
select
	b.dt,
	b.ProductId,
	b.AutoId,
	b.UserId,
	b.PayChannelidId,
	b.Used,
	b.OrderId,
	1 as status,
	b.Flag,
	b.CreateTime,
	b.GetTime,
	b.ItemCount,
	b.SystemType,
	b.ReceiveDate,
	b.MT,
	b.CouponId,
	b.PackageId,
	b.ShopItem,
	b.ExtInfo,
	b.VipExpireTime,
	b.RealMoney,
	b.AwardMoney,
	b.PayConfigId,
	b.CoreVer,
	b.DeviceGUID,
	b.TestFlag,
	b.BaseAmount,
	b.Version,
	b.SubPayType,
	b.GiftMoney,
	b.OrderInitTime,
	b.CooOrderExtInfo,
	b.product_data,
	a.ScheduleTime as refund_timem,
	now() as etl_time
from 	dwd.dwd_trade_user_payorder  b
join
(
	select Id,ClassType,  get_json_string(Args,'$.OrderId')   orderid,ScheduleTime,Status,ExecCount,ExecTime
	FROM  ods.ods_sr_trade_commandtask
	where ScheduleTime >='${bf_1_dt}'
) a
on b.orderid = a.orderid
;
