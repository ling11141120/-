----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_user_video_cn_login_info
-- workflow_version : 2
-- create_user      : zhengtt
-- task_name        : dwd_user_video_cn_login_info
-- task_version     : 2
-- update_time      : 2024-11-29 14:05:53
-- sql_path         : \starrocks\tbl_dwd_user_video_cn_login_info\dwd_user_video_cn_login_info
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_user_video_cn_login_info
select 	date(create_time) as dt,Id,log_id,log_type,login_type,user_id,ip,os,
          platform,state,create_time,now() as etl_time
from ods.ods_tidb_cdvideo_tidb_xcx_login
where state = 1 and date(create_time) >= '${bf_1_dt}';
