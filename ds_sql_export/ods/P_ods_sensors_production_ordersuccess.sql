----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_test_zhugl_copy_ordersuccess
-- workflow_version : 7
-- create_user      : zhugl
-- task_name        : tbl_ods_sensors_ordersuccess
-- task_version     : 6
-- update_time      : 2024-01-04 10:19:07
-- sql_path         : \starrocks\sensors_test_zhugl_copy_ordersuccess\tbl_ods_sensors_ordersuccess
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_production_ordersuccess
select
dt,COALESCE (rid,track_id) id,track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm,device_id,login_id,identity_login_id,device_lang,event,distinct_id,identity_user_id,app_product_id,send_id,app_core_ver,app_channel,app_product_x,app_lang_id,recharge_amount,present_gift,real_recharge,pay_source,payment_method,recharge_type,subscription_days,current_coin,current_gift,activity_id,parent_group_id,group_id,
app_module,project_id,lib_version,app_version,now()
from ods_log.ods_sensors_production_ordersuccess_hive where dt ='${bf_1_dt}';
