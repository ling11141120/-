----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_exposure_bulu
-- workflow_version : 1
-- create_user      : admin
-- task_name        : dwd_flow_sensors_itemclick_event
-- task_version     : 1
-- update_time      : 2023-10-18 13:34:11
-- sql_path         : \starrocks\sensors_exposure_bulu\dwd_flow_sensors_itemclick_event
----------------------------------------------------------------
-- SQL语句
insert  into dwd.dwd_flow_sensors_itemclick_event
select dt,COALESCE (rid,track_id),track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm,device_id,login_id,identity_login_id,device_lang,ip,
country,province,city,event,distinct_id,manufacturer,brand,model,os,os_version,app_version,app_core_ver,
app_channel,app_product_x,app_product_id,app_lang_id,app_id,page_id,page_name,referrer,referrer_title,
book_id,is_bookshelf,send_id,module_channel_id,list_id,list_name,list_index,element_id,element_name,now() etl_time
from ods.ods_flow_sensors_itemclick_event_hive where dt = '${bf_1_dt}';
