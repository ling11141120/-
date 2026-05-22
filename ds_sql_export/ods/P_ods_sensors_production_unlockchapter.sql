----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_test_zhugl_copy_unlockchapter
-- workflow_version : 4
-- create_user      : zhugl
-- task_name        : tbl_ods_sensors_unlockchapter
-- task_version     : 3
-- update_time      : 2023-12-14 11:43:26
-- sql_path         : \starrocks\sensors_test_zhugl_copy_unlockchapter\tbl_ods_sensors_unlockchapter
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_production_unlockchapter
select dt,COALESCE (rid,track_id) id,track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss')  event_tm,device_id,login_id,identity_login_id,device_lang,event,distinct_id,identity_user_id,app_product_id,send_id,app_core_ver,app_channel,app_product_x,
app_lang_id,book_id,chapter_ids,coin_consume,gift_consume,current_coin,current_gift,session_id,unlock_type,now()
from ods_log.ods_sensors_production_unlockchapter_hive where dt ='${bf_1_dt}';
