----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_trade_sharpenginepaycenter_gporderchecklist
-- workflow_version : 2
-- create_user      : doupz
-- task_name        : dwd_trade_sharpenginepaycenter_gporderchecklist
-- task_version     : 2
-- update_time      : 2024-02-06 14:55:20
-- sql_path         : \starrocks\tbl_dwd_trade_sharpenginepaycenter_gporderchecklist\dwd_trade_sharpenginepaycenter_gporderchecklist
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_trade_sharpenginepaycenter_gporderchecklist
select
 dt as dt
,Id as id
,OrderID as order_id
,OrderTime as order_time
,AppName as app_name
,OrderType as order_type
,OrderStatus as order_status
,OrderMoney as order_money
,AddTime as add_time
,IsRenew as is_renew
,IsLosed as is_losed
,IsSent as is_sent
,SKU as sku
,Token as token
,PackageName as package_name
,IsZeroMoney as is_zero_money
,ZeroMoneySentToServer as zero_money_sent_to_server
,HistoryOrderId as history_order_id
,OrderTime1 as order_time1
,OrderTime2 as order_time2
,OrderTime3 as order_time3
,RowVersion as row_version
,CURRENT_TIMESTAMP() etl_time
from ods.ods_tidb_sharpenginepaycenter_hk_gporderchecklist
where dt between '${bf_3_dt}' and '${bf_1_dt}';
