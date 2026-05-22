----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_short_video_star_end_watching
-- workflow_version : 3
-- create_user      : zhugl
-- task_name        : tbl_dwd_short_video_star_end_watching_end
-- task_version     : 2
-- update_time      : 2023-12-27 10:15:07
-- sql_path         : \starrocks\tbl_dwd_short_video_star_end_watching\tbl_dwd_short_video_star_end_watching_end
----------------------------------------------------------------
-- SQL语句
insert  into dwd.dwd_short_video_star_end_watching (login_id ,product_id ,shortplay_id ,episode_id,max_end_watch_tm)
select login_id ,product_id ,shortplay_id ,episode_id ,event_tm
from dwd.dwd_sensors_cd_video_endwatching_view  where (dt>='${bf_1_dt}' or date(etl_tm) >= '${bf_1_dt}') and product_id =6833;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_short_video_star_end_watching
-- workflow_version : 3
-- create_user      : zhugl
-- task_name        : tbl_dwd_short_video_star_end_watching_start
-- task_version     : 2
-- update_time      : 2023-12-27 10:15:07
-- sql_path         : \starrocks\tbl_dwd_short_video_star_end_watching\tbl_dwd_short_video_star_end_watching_start
----------------------------------------------------------------
-- SQL语句
insert  into dwd.dwd_short_video_star_end_watching (login_id ,product_id ,shortplay_id ,episode_id,min_start_watch_tm)
select login_id ,product_id ,shortplay_id ,episode_id ,event_tm
from dwd.dwd_sensors_cd_video_startwatching_view where  (dt>='${bf_1_dt}' or date(etl_tm) >= '${bf_1_dt}') and product_id =6833;
