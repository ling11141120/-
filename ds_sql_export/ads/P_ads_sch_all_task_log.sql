----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : run_end
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : run_end
-- task_version     : 1
-- update_time      : 2025-03-07 00:20:41
-- sql_path         : \starrocks\run_end\run_end
----------------------------------------------------------------
-- SQL语句
INSERT  INTO ads.ads_sch_all_task_log
values ('${dt}',1,'sch_all',NOW());

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : run_start
-- workflow_version : 8
-- create_user      : xixg
-- task_name        : run_start
-- task_version     : 8
-- update_time      : 2025-05-28 18:02:03
-- sql_path         : \starrocks\run_start\run_start
----------------------------------------------------------------
-- SQL语句
INSERT  INTO ads.ads_sch_all_task_log
values ('${dt}',0,'sch_all',NOW());
