----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_video_user_watch_a
-- workflow_version : 13
-- create_user      : linq
-- task_name        : dws_video_user_watch_a_agg_mid1
-- task_version     : 3
-- update_time      : 2024-09-30 20:12:17
-- sql_path         : \starrocks\tbl_dws_video_user_watch_a\dws_video_user_watch_a_agg_mid1
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_video_user_watch_a_agg_mid1
select 6833 as product_id,account_id as user_id,series_id,epis_num,now()
from dwd.dwd_video_short_video_epis_history
where create_time='${bf_1_dt}';
