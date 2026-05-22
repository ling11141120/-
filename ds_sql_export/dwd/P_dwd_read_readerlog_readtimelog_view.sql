----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_read_readerlog_readtimelog
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : tbl_dwd_read_readerlog_readtimelog
-- task_version     : 2
-- update_time      : 2023-10-23 11:42:56
-- sql_path         : \starrocks\tbl_dwd_read_readerlog_readtimelog\tbl_dwd_read_readerlog_readtimelog
----------------------------------------------------------------
-- SQL语句
delete FROM  dwd.dwd_read_readerlog_readtimelog_view where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}';

-- SQL语句
insert into dwd.dwd_read_readerlog_readtimelog_view
select
	dt,product_id,Id,UserId,IP,MT,IMEI,IMSI,MAC,Ver,Chl,Device,SW,SH,DeviceGUID,`Time`,BookId,CreateTime,AppId,now()
	from ods_log.ods_tidb_readerlog_log_readtimelog   where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}';
