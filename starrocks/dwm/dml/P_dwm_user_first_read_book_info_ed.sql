----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_user_first_read_book_info_ed
-- workflow_version : 2
-- create_user      : yanxh
-- task_name        : dwm_user_first_read_book_info_ed
-- task_version     : 2
-- update_time      : 2025-11-11 15:56:07
-- sql_path         : \starrocks\tbl_dwm_user_first_read_book_info_ed\dwm_user_first_read_book_info_ed
----------------------------------------------------------------
-- SQL语句
insert into dwm.dwm_user_first_read_book_info_ed
select product_id,user_id,book_id, min(create_time)  as fst_read_tm ,now() as etl_tm from dwd.dwd_read_user_chapter_view
where dt>='${bf_1_dt}'
group by 1,2,3;
