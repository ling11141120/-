----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_trade_sensors_log_payment_link
-- workflow_version : 8
-- create_user      : xixg
-- task_name        : dwd_trade_sensors_log_payment_link
-- task_version     : 8
-- update_time      : 2025-07-14 01:07:50
-- sql_path         : \starrocks\tbl_dwd_trade_sensors_log_payment_link\dwd_trade_sensors_log_payment_link
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_trade_sensors_log_payment_link
select
    dt
     ,rid
     ,app_product_id
     ,login_id
     ,app_core_ver
     ,mt
     ,app_version
     ,step
     ,uuid
     ,page_id
     ,page_name
     ,item_id
     ,recharge_amount
     ,present_gift
     ,real_recharge
     ,parent_group_id
     ,group_id
     ,pay_id
     ,pay_type
     ,order_id
     ,jump_url
     ,is_success
     ,error_parameter
     ,pay_source
     ,payment_method
     ,recharge_type
     ,subscription_days
     ,current_coin
     ,current_gift
     ,event_tm
     ,CURRENT_TIMESTAMP() etl_time
from ods_log.ods_sensors_production_orderpayprocess
where dt >= DATE_FORMAT(DATE_SUB('${bf_1_dt}',4),'%Y-%m-%d')
  and step is not null
  and `uuid` <>''
  and rid is not NULL
  and login_id is not null
  and cast(login_id as int) is not null;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_trade_sensors_log_payment_link_error
-- workflow_version : 11
-- create_user      : doupz
-- task_name        : dwd_trade_sensors_log_payment_link
-- task_version     : 10
-- update_time      : 2025-01-11 15:33:22
-- sql_path         : \starrocks\tbl_dwd_trade_sensors_log_payment_link_error\dwd_trade_sensors_log_payment_link
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_trade_sensors_log_payment_link
select
    dt
     ,rid
     ,app_product_id
     ,user_id
     ,app_core_ver
     ,mt
     ,app_version
     ,step
     ,uuid
     ,page_id
     ,page_name
     ,item_id
     ,recharge_amount
     ,present_gift
     ,real_recharge
     ,parent_group_id
     ,group_id
     ,pay_id
     ,pay_type
     ,order_id
     ,jump_url
     ,is_success
     ,error_parameter
     ,pay_source
     ,payment_method
     ,recharge_type
     ,subscription_days
     ,current_coin
     ,current_gift
     ,event_tm
     ,CURRENT_TIMESTAMP() etl_time
from ods_log.ods_sensors_production_orderpayprocess
where dt >= DATE_FORMAT(DATE_SUB('${bf_1_dt}',4),'%Y-%m-%d')
  and step is not null
  and `uuid` <>''
  and rid is not NULL;
