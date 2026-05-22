----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_yqx_sensors_cd_video_unlockEpisode
-- workflow_version : 9
-- create_user      : yaoqx
-- task_name        : tbl_ods_sensors_unlockEpisode
-- task_version     : 7
-- update_time      : 2024-01-20 15:47:17
-- sql_path         : \starrocks\tbl_yqx_sensors_cd_video_unlockEpisode\tbl_ods_sensors_unlockEpisode
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_cd_video_unlockEpisode
select
    dt,
    COALESCE (rid,track_id)id,
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
  shortplay_id,
  episode_id,
  coin_consume,
  gift_consume,
  current_coin,
  current_gift,
  unlock_type,
  project_id,
    now()
from ods_log.ods_sensors_cd_video_unlockepisode_hive where dt ='${bf_1_dt}' and  COALESCE (rid,track_id) is not  null ;

-- SQL语句
-- 要加判空;
