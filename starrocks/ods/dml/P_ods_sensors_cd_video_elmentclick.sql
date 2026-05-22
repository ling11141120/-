----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_yqx_ods_sensors_cd_video_elmentclick
-- workflow_version : 7
-- create_user      : yaoqx
-- task_name        : tbl_ods_sensors_elementClick
-- task_version     : 6
-- update_time      : 2024-01-20 15:43:14
-- sql_path         : \starrocks\tbl_yqx_ods_sensors_cd_video_elmentclick\tbl_ods_sensors_elementClick
----------------------------------------------------------------
-- 前置SQL语句
REFRESH EXTERNAL TABLE  ods_log.ods_sensors_cd_video_elmentclick_hive;

-- SQL语句
insert into ods_log.ods_sensors_cd_video_elmentclick
select
dt,COALESCE (rid,track_id)id,rid,track_id,
  event,
  event_tm,
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
  page_id,
  page_name,
  element_id,
  element_name,
  element_type,
  shortplay_id,
  episode_id,
  watch_episode_sort,
  button_status,
  element_content,
  project_id,
  now()
 from ods_log.ods_sensors_cd_video_elmentclick_hive  where dt ='${bf_1_dt}' and  COALESCE (rid,track_id) is not  null ;
