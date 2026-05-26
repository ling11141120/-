----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_video_short_video_epis_watch_log
-- workflow_version : 1
-- create_user      : zhengtt
-- task_name        : dwd_video_short_video_epis_watch_log
-- task_version     : 1
-- update_time      : 2024-01-23 19:22:35
-- sql_path         : \starrocks\tbl_dwd_video_short_video_epis_watch_log\dwd_video_short_video_epis_watch_log
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_video_short_video_epis_watch_log
select dt, id,create_time, account_id, lang_id, series_id, epis_id, epis_num, ts, now() as etl_time
from ods.ods_tidb_short_video_log_ext_epis_watch_log_part2
where dt = '${bf_1_dt}';
