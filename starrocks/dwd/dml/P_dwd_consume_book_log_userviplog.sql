----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_consume_book_log_userviplog
-- workflow_version : 1
-- create_user      : zhugl
-- task_name        : tbl_dwd_consume_book_log_userviplog
-- task_version     : 1
-- update_time      : 2023-09-09 18:32:05
-- sql_path         : \starrocks\tbl_dwd_consume_book_log_userviplog\tbl_dwd_consume_book_log_userviplog
----------------------------------------------------------------
-- SQL语句
delete FROM  dwd.dwd_consume_book_log_userviplog where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}';

-- SQL语句
insert into dwd.dwd_consume_book_log_userviplog
select
	dt,ProductId,Id,UserId,CreateTime,Amount,RemainAmount,BookId,ChapterIds,ChapterName,PayType,MT,Seq,IsFirst,VipType,AppId,now()
	from ods.ods_book_log_userviplog   where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}';
