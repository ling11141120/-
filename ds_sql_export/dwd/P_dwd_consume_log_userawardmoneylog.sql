----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_consume_log_userawardmoneylog
-- workflow_version : 1
-- create_user      : zhugl
-- task_name        : tbl_dwd_consume_log_userawardmoneylog
-- task_version     : 1
-- update_time      : 2023-09-09 18:32:50
-- sql_path         : \starrocks\tbl_dwd_consume_log_userawardmoneylog\tbl_dwd_consume_log_userawardmoneylog
----------------------------------------------------------------
-- SQL语句
delete FROM  dwd.dwd_consume_log_userawardmoneylog where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}';

-- SQL语句
insert into dwd.dwd_consume_log_userawardmoneylog
select
	dt,ProductId,Id,UserId,CreateTime,Amount,RemainAmount,BookId,ChapterIds,ChapterName,PayType,MT,Seq,VipType,OriginCoin,VipDisPrice,AppId,PositionId,AppGameId,SendId,now()
	from ods.ods_book_log_userawardmoneylog   where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}';
