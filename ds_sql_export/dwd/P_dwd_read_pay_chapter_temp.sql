----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_read_pay_chapter_temp
-- workflow_version : 3
-- create_user      : yanxh
-- task_name        : dwd_read_pay_chapter_temp
-- task_version     : 3
-- update_time      : 2023-12-22 20:18:03
-- sql_path         : \starrocks\tbl_dwd_read_pay_chapter_temp\dwd_read_pay_chapter_temp
----------------------------------------------------------------
-- SQL语句
insert overwrite dwd.dwd_read_pay_chapter_temp
select a.book_id,a.chapter_id,a.serial_number ,now() as etl_time
from dim.dim_book_chapter_info a
where Free_Chapter_Num=1;
