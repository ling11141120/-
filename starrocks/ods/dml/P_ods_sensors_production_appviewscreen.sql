----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_test_zhugl_copy_appviewscreen
-- workflow_version : 5
-- create_user      : zhugl
-- task_name        : tbl_ods_sensors_appviewscreen
-- task_version     : 4
-- update_time      : 2024-01-04 10:33:00
-- sql_path         : \starrocks\sensors_test_zhugl_copy_appviewscreen\tbl_ods_sensors_appviewscreen
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_production_appviewscreen
select dt,COALESCE (rid,track_id)id,track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm,device_id,login_id,identity_login_id,device_lang,event,distinct_id,appId,appLangId,appChannel,appVersionCode,androidId,gaid,deviceLang,mt,
identity_userID,app_version_code,app_product_id,send_id,app_core_ver,app_channel,
app_product_x,app_lang_id,title,screen_name,url,referrer,is_first_day,os,os_version,lib,manufacturer,
app_version,carrier,app_name,referrer_title,ip,city,province,country,identity_android_id,project_id,now()
from ods_log.ods_sensors_appviewscreen_hive where dt ='${bf_1_dt}';
