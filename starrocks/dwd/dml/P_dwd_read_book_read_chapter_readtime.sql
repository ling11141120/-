----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_read_book_read_chapter_readtime
-- workflow_version : 23
-- create_user      : zhengtt
-- task_name        : dwd_read_book_read_chapter_readtime_part1
-- task_version     : 21
-- update_time      : 2025-04-27 20:20:42
-- sql_path         : \starrocks\tbl_dwd_read_book_read_chapter_readtime\dwd_read_book_read_chapter_readtime_part1
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_read_book_read_chapter_readtime
select 	dt
		,productid as product_id
		,userid as user_id
		,bookid as book_id
		,chapterid as chapter_id
		,mt
		,corever
		,prodid
		,appver
		,event
		,createtime as create_time
		,readtime as read_time
		,now() as etl_time
from ods.ods_sensors_book_readtime where dt >= '${bf_5_dt}' and dt <= '${bf_1_dt}'
and bookid is not null and ifnull(userid+0,null) is not null  and ifnull(bookid+0,null) is not null  and length(userid) <= 9 and readtime >= 0;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_read_book_read_chapter_readtime
-- workflow_version : 23
-- create_user      : zhengtt
-- task_name        : dwd_read_book_read_chapter_readtime_part2
-- task_version     : 16
-- update_time      : 2025-04-27 20:20:42
-- sql_path         : \starrocks\tbl_dwd_read_book_read_chapter_readtime\dwd_read_book_read_chapter_readtime_part2
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_read_book_read_chapter_readtime
select 	dt
		,productid as product_id
		,userid as user_id
		,bookid as book_id
		,chapterid as chapter_id
		,mt
		,corever
		,prodid
		,appver
		,event
		,createtime as create_time
		,readtime as read_time
		,now() as etl_time
from ods.ods_sensors_book_readtime where dt >= '${bf_10_dt}' and dt <= '${bf_6_dt}'
and bookid is not null and ifnull(userid+0,null) is not null  and ifnull(bookid+0,null) is not null  and length(userid) <= 9 and readtime >= 0;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_read_book_read_chapter_readtime
-- workflow_version : 23
-- create_user      : zhengtt
-- task_name        : dwd_read_book_read_chapter_readtime_part3
-- task_version     : 3
-- update_time      : 2025-04-27 20:20:42
-- sql_path         : \starrocks\tbl_dwd_read_book_read_chapter_readtime\dwd_read_book_read_chapter_readtime_part3
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_read_book_read_chapter_readtime
select 	dt
		,productid as product_id
		,userid as user_id
		,bookid as book_id
		,chapterid as chapter_id
		,mt
		,corever
		,prodid
		,appver
		,event
		,createtime as create_time
		,readtime as read_time
		,now() as etl_time
from ods.ods_sensors_book_readtime where dt >= '${bf_15_dt}' and dt <= '${bf_11_dt}'
and bookid is not null and ifnull(userid+0,null) is not null  and ifnull(bookid+0,null) is not null  and length(userid) <= 9 and readtime >= 0;
