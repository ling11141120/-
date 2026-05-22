----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_test_zhugl_copy_startwatching
-- workflow_version : 8
-- create_user      : zhugl
-- task_name        : tbl_ods_sensors_startwatching
-- task_version     : 3
-- update_time      : 2023-12-25 20:25:08
-- sql_path         : \starrocks\sensors_test_zhugl_copy_startwatching\tbl_ods_sensors_startwatching
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_cd_video_startwatching
select dt,COALESCE (rid,track_id) id,rid,track_id,event,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss')  event_tm,app_channel,app_id,app_lang_id,device_lang,login_id,product_id,app_version,os,ip,city,province,country,shortplay_id,if_first_watch_shortplay,episode_id,watch_episode_sort,watch_source_id,watch_source_name,watch_source_page_id,watch_source_page_name,watch_speeds,now() etl_tm
from ods_log.ods_sensors_cd_video_startwatching_hive where dt ='${bf_1_dt}' and COALESCE (rid,track_id) is not  null;
