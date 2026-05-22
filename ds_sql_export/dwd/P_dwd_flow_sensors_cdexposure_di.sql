----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : hive2StarRocks_dwd_flow_sensors_cdexposure_di
-- workflow_version : 1
-- create_user      : zhugl
-- task_name        : hive2StrarRocks_dwd_flow_sensors_cdexposure_di_delete
-- task_version     : 1
-- update_time      : 2023-09-09 18:12:25
-- sql_path         : \starrocks\hive2StarRocks_dwd_flow_sensors_cdexposure_di\hive2StrarRocks_dwd_flow_sensors_cdexposure_di_delete
----------------------------------------------------------------
-- SQL语句
delete from dwd.dwd_flow_sensors_cdexposure_di where  dt='${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_flow_sensors_cdexposure_di_2
-- workflow_version : 1
-- create_user      : zhugl
-- task_name        : hive2StrarRocks_dwd_flow_sensors_cdexposure_di_delete_2
-- task_version     : 1
-- update_time      : 2023-09-09 17:57:57
-- sql_path         : \starrocks\tbl_dwd_flow_sensors_cdexposure_di_2\hive2StrarRocks_dwd_flow_sensors_cdexposure_di_delete_2
----------------------------------------------------------------
-- SQL语句
delete from dwd.dwd_flow_sensors_cdexposure_di where  dt='${bf_2_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_flow_sensors_cdexposure_di_3
-- workflow_version : 1
-- create_user      : zhugl
-- task_name        : hive2StrarRocks_dwd_flow_sensors_cdexposure_di_delete_3
-- task_version     : 1
-- update_time      : 2023-09-09 17:57:25
-- sql_path         : \starrocks\tbl_dwd_flow_sensors_cdexposure_di_3\hive2StrarRocks_dwd_flow_sensors_cdexposure_di_delete_3
----------------------------------------------------------------
-- SQL语句
delete from dwd.dwd_flow_sensors_cdexposure_di where  dt='${bf_3_dt}';
