----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_read_readerlog_log_userwatchvideo3log
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : tbl_dwd_read_readerlog_log_userwatchvideo3log
-- task_version     : 2
-- update_time      : 2023-10-21 17:34:30
-- sql_path         : \starrocks\tbl_dwd_read_readerlog_log_userwatchvideo3log\tbl_dwd_read_readerlog_log_userwatchvideo3log
----------------------------------------------------------------
-- SQL语句
delete FROM  dwd.dwd_read_readerlog_log_userwatchvideo3log_view where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}';

-- SQL语句
insert into dwd.dwd_read_readerlog_log_userwatchvideo3log_view
select
	dt,product_id,Id,Mt,Core,UniqueCdReaderId,`Position`,UserId,CreateTime,AppId,now()
	from ods_log.ods_tidb_readerlog_Log_UserWatchVideo3Log   where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}';
