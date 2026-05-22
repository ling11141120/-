----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_yqx_ods_sensors_operationpositionexposure
-- workflow_version : 13
-- create_user      : yaoqx
-- task_name        : ods_sensors_cd_video_production_operationpositionexposure
-- task_version     : 9
-- update_time      : 2024-01-17 18:49:23
-- sql_path         : \starrocks\tbl_yqx_ods_sensors_operationpositionexposure\ods_sensors_cd_video_production_operationpositionexposure
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_cd_video_production_operationpositionexposure
select
  dt,
  COALESCE (rid,track_id)id,
  rid,
  track_id,
  event,
  from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm,
  app_channel,
  app_id,
  app_lang_id,
  device_lang,
  login_id,
  product_id,
  app_version,
  os,
  ip,
  city,
  province,
  country,
  lib,
  device_id,
  identity_login_id,
  distinct_id,
  identity_user_id,
  app_product_id,
  send_id,
  app_core_ver,
  app_product_x,
  lib_version,
  page_id,
  page_name,
  element_id,
  element_type,
  element_name,
  element_content,
  activity_id,
  event_strategy_id,
  group_id,
  project_id,
  parent_group_id,
  countdown,
  start_type,
  now()
from ods_log.ods_sensors_cd_video_production_operationpositionexposure_hive where dt ='${bf_1_dt}';
