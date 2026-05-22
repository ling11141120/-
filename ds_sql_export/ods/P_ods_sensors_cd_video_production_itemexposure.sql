----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : test_itemexposure
-- workflow_version : 3
-- create_user      : linq
-- task_name        : test_itemexposure
-- task_version     : 3
-- update_time      : 2024-02-01 18:12:08
-- sql_path         : \starrocks\test_itemexposure\test_itemexposure
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_cd_video_production_itemexposure
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
  device_id,
  identity_login_id,
  distinct_id,
  identity_user_id,
  app_product_id,
  send_id,
  app_core_ver,
  app_product_x,
  page_name,
  page_id,
  element_name,
  element_id,
  book_id,
  is_bookshelf,
  module_channel_id,
  list_id,
  list_style,
  list_name,
  list_index,
  parent_group_id,
  group_id,
  current_book_id,
  ranking_type,
  gender,
  period,
  activity_id,
  app_module,
  event_strategy_id,
  project_id,
  element_type,
  shortplay_id,
  is_shortplayshelf,
  channel_id,
  channel_name,
  keyword,
  search_mode,
  search_hit_type,
  now()
 from ods_log.ods_sensors_cd_video_production_itemexposure_hive  where dt ='${bf_1_dt}' and  COALESCE (rid,track_id) is not  null
    and hour(event_tm) between 13 and 23;
