----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_test_zhugl_copy_endwatching
-- workflow_version : 5
-- create_user      : zhugl
-- task_name        : tbl_ods_sensors_endwatching
-- task_version     : 3
-- update_time      : 2023-12-25 20:25:58
-- sql_path         : \starrocks\sensors_test_zhugl_copy_endwatching\tbl_ods_sensors_endwatching
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_cd_video_endwatching
select  dt,COALESCE (rid,track_id)  id,rid,track_id,event,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm,app_channel,app_id,app_lang_id,device_lang,login_id,product_id,app_version,os,ip,city,province,country,shortplay_id,episode_id,page_id,page_name,watch_episode_sort,watch_speeds,watch_progress,now() etl_tm
from ods_log.ods_sensors_cd_video_endwatching_hive where dt ='${bf_1_dt}' and COALESCE (rid,track_id)  is not  null ;
