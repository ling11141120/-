----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_market_group_user
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : tbl_dwd_market_group_user
-- task_version     : 2
-- update_time      : 2023-11-17 13:37:39
-- sql_path         : \starrocks\tbl_dwd_market_group_user\tbl_dwd_market_group_user
----------------------------------------------------------------
-- 前置SQL语句
delete from  dwd.dwd_market_group_user where dt ='${bf_1_dt}';

-- SQL语句
insert into dwd.dwd_market_group_user
select
dt,id,product_id,group_id,user_id,start_time,end_time,create_time,NOW()
from ods.ods_tidb_bd_user_group_group_user where dt ='${bf_1_dt}';
