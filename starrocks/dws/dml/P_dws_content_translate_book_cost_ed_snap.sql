----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_content_translate_book_cost_ed_snap
-- workflow_version : 1
-- create_user      : zhengtt
-- task_name        : dws_content_translate_book_cost_ed_snap
-- task_version     : 1
-- update_time      : 2024-01-22 20:01:06
-- sql_path         : \starrocks\tbl_dws_content_translate_book_cost_ed_snap\dws_content_translate_book_cost_ed_snap
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_content_translate_book_cost_ed_snap
select dt, book_id, book_name, site_id, author_name, book_cost, toufang_cost, toufang_cost_rmb, translate_cost, translate_cost_rmb, proofread_length_today, price, etl_time
from dws.dws_content_translate_book_cost_ed
where dt = '${bf_1_dt}';
