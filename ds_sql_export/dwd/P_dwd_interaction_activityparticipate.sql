----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_interaction_activityparticipate
-- workflow_version : 3
-- create_user      : zhugl
-- task_name        : tbl_dwd_interaction_activityparticipate
-- task_version     : 3
-- update_time      : 2025-05-28 17:06:12
-- sql_path         : \starrocks\tbl_dwd_interaction_activityparticipate\tbl_dwd_interaction_activityparticipate
----------------------------------------------------------------
-- SQL语句
INSERT OVERWRITE dwd.dwd_interaction_activityparticipate
select productid,Id,Pid,`Type`,LastParticipateTime,GameOrBannerId,LogType,ClickType,NOW()
from ods.ods_tidb_readernovel_tidb_xx_activityparticipate;
