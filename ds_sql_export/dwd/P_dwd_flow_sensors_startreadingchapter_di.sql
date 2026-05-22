----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_flow_sensors_startreadingchapter_di
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : hive2StrarRocks_dwd_flow_sensors_startreadingchapter_di_delete_1
-- task_version     : 2
-- update_time      : 2024-02-06 15:04:55
-- sql_path         : \starrocks\tbl_dwd_flow_sensors_startreadingchapter_di\hive2StrarRocks_dwd_flow_sensors_startreadingchapter_di_delete_1
----------------------------------------------------------------
-- SQL语句
delete from dwd.dwd_flow_sensors_startreadingchapter_di where  dt='${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_flow_sensors_startreadingchapter_di
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : hive2StrarRocks_dwd_flow_sensors_startreadingchapter_di_delete_2
-- task_version     : 2
-- update_time      : 2024-02-06 15:04:55
-- sql_path         : \starrocks\tbl_dwd_flow_sensors_startreadingchapter_di\hive2StrarRocks_dwd_flow_sensors_startreadingchapter_di_delete_2
----------------------------------------------------------------
-- SQL语句
delete from dwd.dwd_flow_sensors_startreadingchapter_di where  dt='${bf_2_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_flow_sensors_startreadingchapter_di
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : hive2StrarRocks_dwd_flow_sensors_startreadingchapter_di_delete_3
-- task_version     : 2
-- update_time      : 2024-02-06 15:04:55
-- sql_path         : \starrocks\tbl_dwd_flow_sensors_startreadingchapter_di\hive2StrarRocks_dwd_flow_sensors_startreadingchapter_di_delete_3
----------------------------------------------------------------
-- SQL语句
delete from dwd.dwd_flow_sensors_startreadingchapter_di where  dt='${bf_3_dt}';
