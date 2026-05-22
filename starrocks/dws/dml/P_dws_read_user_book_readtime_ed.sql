----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_book_readtime_ed
-- workflow_version : 13
-- create_user      : zhengtt
-- task_name        : tbl_dws_read_user_book_readtime_ed
-- task_version     : 12
-- update_time      : 2025-05-28 18:29:53
-- sql_path         : \starrocks\tbl_dws_read_user_book_readtime_ed\tbl_dws_read_user_book_readtime_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_user_book_readtime_ed
select dt,product_id,book_id,user_id,sum(read_time) as read_times
from dwd.dwd_read_book_read_book_readtime
where dt >= '${bf_15_dt}' and dt <= '${bf_1_dt}'
group by 1,2,3,4;
