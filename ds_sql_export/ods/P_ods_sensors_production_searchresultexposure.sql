----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_test_zhugl_copy_searchresultexposure
-- workflow_version : 3
-- create_user      : zhugl
-- task_name        : tbl_ods_sensors_element_expose
-- task_version     : 2
-- update_time      : 2023-12-22 19:14:35
-- sql_path         : \starrocks\sensors_test_zhugl_copy_searchresultexposure\tbl_ods_sensors_element_expose
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_production_searchresultexposure
select dt,COALESCE (rid,track_id)   id,track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss')  event_tm,device_id,login_id,identity_login_id,device_lang,event,distinct_id,identity_user_id,app_product_id,send_id,app_core_ver,app_channel,app_product_x,app_lang_id,page_name,page_id,element_name,element_id,search_mode,keyword,now() etl_tm
from ods_log.ods_sensors_production_searchresultexposure_hive where dt ='${bf_1_dt}';
