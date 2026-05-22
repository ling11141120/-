----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_test_zhugl_copy_itemexposure
-- workflow_version : 11
-- create_user      : zhugl
-- task_name        : tbl_ods_sensors_operationpositionexposure_event
-- task_version     : 8
-- update_time      : 2024-01-03 21:59:21
-- sql_path         : \starrocks\sensors_test_zhugl_copy_itemexposure\tbl_ods_sensors_operationpositionexposure_event
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_production_itemexposure
select
dt,COALESCE (rid,track_id) id,track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss')  event_tm,device_id,login_id,identity_login_id,device_lang,event,distinct_id,identity_user_id,app_product_id,send_id,app_core_ver,app_channel,app_product_x,app_lang_id,page_name,page_id,element_name,element_id,book_id,is_bookshelf,module_channel_id,list_id,list_style,list_name,list_index,parent_group_id,group_id,current_book_id,ranking_type,gender,period,activity_id,app_module,event_strategy_id,project_id,now()
from ods_log.ods_sensors_production_itemexposure_hive where dt ='${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_test_zhugl_copy_itemexposure_copy_20240103140856947
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : tbl_ods_sensors_operationpositionexposure_event
-- task_version     : 1
-- update_time      : 2024-01-03 14:08:57
-- sql_path         : \starrocks\sensors_test_zhugl_copy_itemexposure_copy_20240103140856947\tbl_ods_sensors_operationpositionexposure_event
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_production_itemexposure
select
dt,COALESCE (rid,track_id) id,track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss')  event_tm,device_id,login_id,identity_login_id,device_lang,event,distinct_id,identity_user_id,app_product_id,send_id,app_core_ver,app_channel,app_product_x,app_lang_id,page_name,page_id,element_name,element_id,book_id,is_bookshelf,module_channel_id,list_id,list_style,list_name,list_index,parent_group_id,group_id,current_book_id,ranking_type,gender,period,activity_id,app_module,event_strategy_id,project_id,now()
from ods_log.ods_sensors_production_itemexposure_hive where dt ='${bf_1_dt}';
