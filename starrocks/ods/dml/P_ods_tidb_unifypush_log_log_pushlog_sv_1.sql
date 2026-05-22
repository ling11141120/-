----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 补数-ods_tidb_unifypush_log_log_pushlog_sv
-- workflow_version : 1
-- create_user      : chenmo
-- task_name        : ods_tidb_unifypush_log_log_pushlog_sv_1
-- task_version     : 1
-- update_time      : 2025-10-15 11:24:08
-- sql_path         : \starrocks\补数-ods_tidb_unifypush_log_log_pushlog_sv\ods_tidb_unifypush_log_log_pushlog_sv_1
----------------------------------------------------------------
-- SQL语句
insert into ods.ods_tidb_unifypush_log_log_pushlog_sv_1
select * from ods.ods_tidb_unifypush_log_log_pushlog_sv where dt = '${dt}';
