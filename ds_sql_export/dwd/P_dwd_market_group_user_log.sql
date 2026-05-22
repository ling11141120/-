----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_market_group_user_log
-- workflow_version : 6
-- create_user      : zhugl
-- task_name        : tbl_dwd_market_group_user_log
-- task_version     : 5
-- update_time      : 2025-03-27 19:22:56
-- sql_path         : \starrocks\tbl_dwd_market_group_user_log\tbl_dwd_market_group_user_log
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_market_group_user_log
select
dt,id,create_time,group_id,product_id,user_id,NOW()
from ods.ods_tidb_bd_user_group_group_user_log where dt ='${bf_1_dt}';
