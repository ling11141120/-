----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_test_zhugl_copy_operationpositionexposure
-- workflow_version : 17
-- create_user      : zhugl
-- task_name        : 短剧的同步代码tbl_ods_sensors_operationpositionexposure_event_2si_471
-- task_version     : 10
-- update_time      : 2024-01-15 16:03:54
-- sql_path         : \starrocks\sensors_test_zhugl_copy_operationpositionexposure\短剧的同步代码tbl_ods_sensors_operationpositionexposure_event_2si_471
----------------------------------------------------------------
-- SQL语句
-- hive 外表同步数据到sr

insert into ods_log.ods_sensors_production_operationpositionexposure
select dt,COALESCE (rid,track_id)id,track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm,device_id,login_id,identity_login_id,device_lang,event,distinct_id,
identity_userID identity_user_id,app_product_id,send_id,app_core_ver,app_channel,app_product_x,app_lang_id,page_name,page_id,
element_name,element_id,activity_id,parent_group_id,group_id,countdown,event_strategy_id,start_type,project_id,now()
 from ods_log.ods_sensors_operationpositionexposure_event_hive where dt ='${bf_1_dt}';
