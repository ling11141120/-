----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_sv_group_user_experiment_log
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : dwd_sv_group_user_experiment_log
-- task_version     : 2
-- update_time      : 2025-06-06 14:05:11
-- sql_path         : \starrocks\tbl_dwd_sv_group_user_experiment_log\dwd_sv_group_user_experiment_log
----------------------------------------------------------------
-- SQL语句
insert into dwd.`dwd_sv_group_user_experiment_log`
select user_id,create_time,experiment_id,scene_id,sr_createtime,sr_updatetime
from ods.`ods_sv_group_user_experiment_log`
where create_time>='${bf_3_dt}';
