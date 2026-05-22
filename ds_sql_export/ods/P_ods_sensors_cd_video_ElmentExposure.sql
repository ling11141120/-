----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_yqx_ods_sensors_cd_video_ElmentExposure
-- workflow_version : 1
-- create_user      : yaoqx
-- task_name        : tbl_ods_sensors_elementexposure
-- task_version     : 1
-- update_time      : 2024-01-19 17:13:18
-- sql_path         : \starrocks\tbl_yqx_ods_sensors_cd_video_ElmentExposure\tbl_ods_sensors_elementexposure
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_cd_video_ElmentExposure
select
    dt,
    COALESCE (rid,track_id)id,
    rid      ,
    track_id ,
    from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm,
    event    ,
    app_channel ,
    app_id      ,
    app_lang_id ,
    device_lang ,
    login_id    ,
    product_id  ,
    app_version ,
    os ,
    ip ,
    city     ,
    province ,
    country  ,
    lib      ,
    page_name,
    element_id,
    element_name,
    shortplay_id,
    episode_id,
    watch_episode_sort,
    button_status,
    element_content,
    project_id ,
    now()
from ods_log.ods_sensors_cd_video_elementexposure_hive where dt ='${bf_1_dt}' and  COALESCE (rid,track_id) is not  null ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_yqx_ods_sensors_elementExposure
-- workflow_version : 5
-- create_user      : yaoqx
-- task_name        : tbl_ods_sensors_cd_video_elementExposure
-- task_version     : 5
-- update_time      : 2024-01-20 15:37:01
-- sql_path         : \starrocks\tbl_yqx_ods_sensors_elementExposure\tbl_ods_sensors_cd_video_elementExposure
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_cd_video_ElmentExposure
select
  dt,
  COALESCE(rid, track_id) AS id,
  rid,
  track_id,
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
  page_name,
  element_id,
  element_name,
  shortplay_id,
  episode_id,
  watch_episode_sort,
  button_status,
  element_content,
  project_id,
  now()
from ods_log.ods_sensors_cd_video_elementexposure_hive   where dt ='${bf_1_dt}' and  COALESCE (rid,track_id) is not  null ;
