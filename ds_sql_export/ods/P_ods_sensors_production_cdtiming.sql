----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ods_hive_sensors_production_cdtiming_history_data
-- workflow_version : 5
-- create_user      : yanxh
-- task_name        : ods_sensors_production_cdtiming
-- task_version     : 2
-- update_time      : 2024-01-02 15:03:16
-- sql_path         : \starrocks\tbl_ods_hive_sensors_production_cdtiming_history_data\ods_sensors_production_cdtiming
----------------------------------------------------------------
-- SQL语句
insert into  ods_log.ods_sensors_production_cdtiming
select  dt,COALESCE (rid,track_id) as id ,track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm ,device_id,login_id,identity_login_id,device_lang,event,distinct_id,identity_user_id,app_product_id,
app_core_ver,os,app_version,app_channel,app_lang_id,serial,type,position,channelid,cdtiming,now() as etl_tm  from ods.ods_hive_sensors_production_cdtiming_history_data
where dt='${bf_1_dt}';
