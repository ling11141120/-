----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_test_zhugl_ordercreateaction
-- workflow_version : 3
-- create_user      : zhugl
-- task_name        : tbl_ods_sensors_ordercreateaction
-- task_version     : 2
-- update_time      : 2024-01-04 14:22:35
-- sql_path         : \starrocks\sensors_test_zhugl_ordercreateaction\tbl_ods_sensors_ordercreateaction
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_production_ordercreateaction
select dt,COALESCE (rid,track_id) id,track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm,device_id,login_id,identity_login_id,device_lang,event,distinct_id,identity_user_id,app_product_id,send_id,app_core_ver,app_channel,app_product_x,app_lang_id,lib_version,app_version,page_name,page_id,element_name,element_id,element_type,activity_id,parent_group_id,group_id,recharge_type,recharge_amount,payment_method,pay_source,present_gift,
real_recharge,current_coin,current_gift,list_sort,event_strategy_id,programme_id,app_module,project_id,now () etl_tm
from ods_log.ods_sensors_production_ordercreateaction_hive where dt ='${bf_1_dt}';
