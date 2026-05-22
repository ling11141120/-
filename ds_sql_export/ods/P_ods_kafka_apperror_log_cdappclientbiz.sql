----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ods_kafka_apperror_log_cdappclientbiz_hisdata_import
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : ods_kafka_apperror_log_cdappclientbiz_hisdata
-- task_version     : 1
-- update_time      : 2024-07-04 23:18:49
-- sql_path         : \starrocks\ods_kafka_apperror_log_cdappclientbiz_hisdata_import\ods_kafka_apperror_log_cdappclientbiz_hisdata
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_kafka_apperror_log_cdappclientbiz
select * from ods_log.ods_kafka_apperror_log_cdappclientbiz_bak where dt = '${dt}';
