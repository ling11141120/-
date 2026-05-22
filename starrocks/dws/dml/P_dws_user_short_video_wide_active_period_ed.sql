----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_short_video_wide_active_period_ed
-- workflow_version : 18
-- create_user      : chenmo
-- task_name        : 后置删除僵尸数据
-- task_version     : 6
-- update_time      : 2026-05-07 10:04:53
-- sql_path         : \starrocks\tbl_dws_user_short_video_wide_active_period_ed\后置删除僵尸数据
----------------------------------------------------------------
-- SQL语句
delete from dws.dws_user_short_video_wide_active_period_ed
 where dt >= '${bf_1_dt}'
   and dt <= '${dt}'
   and etl_time< '${cur_etl_tm}';
