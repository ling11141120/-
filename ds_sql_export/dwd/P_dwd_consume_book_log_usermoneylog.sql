----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_consume_book_log_usermoneylog
-- workflow_version : 1
-- create_user      : zhugl
-- task_name        : tbl_dwd_consume_book_log_usermoneylog
-- task_version     : 1
-- update_time      : 2023-09-09 18:32:20
-- sql_path         : \starrocks\tbl_dwd_consume_book_log_usermoneylog\tbl_dwd_consume_book_log_usermoneylog
----------------------------------------------------------------
-- SQL语句
delete FROM  dwd.dwd_consume_book_log_usermoneylog where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}';

-- SQL语句
insert into dwd.dwd_consume_book_log_usermoneylog
select
	dt,ProductId,Id,UserId,CreateTime,Amount,RemainAmount,BookId,ChapterIds,ChapterName,PayType,MT,Seq,VipType,OriginCoin,VipDisPrice,AppId,PositionId,AppGameId,SendId,now()
	from ods.ods_book_log_usermoneylog   where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}';
