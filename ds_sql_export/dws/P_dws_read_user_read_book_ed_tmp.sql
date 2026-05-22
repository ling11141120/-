----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_roll_a
-- workflow_version : 27
-- create_user      : linq
-- task_name        : dws_read_user_read_book_ed_tmp
-- task_version     : 3
-- update_time      : 2025-06-23 16:04:55
-- sql_path         : \starrocks\tbl_dws_read_user_read_roll_a\dws_read_user_read_book_ed_tmp
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_read_user_read_book_ed_tmp
select  product_id,
        user_id,
       bitmap_union(to_bitmap(Book_Id))                    as total_read_bookids,
       bitmap_union(to_bitmap(concat(book_id, Chapter_Id))) as total_read_chp_ids,
       1                                                  as total_read_days,
       now() as etl_time
from dwd.dwd_read_user_chapter_view
where dt = '${bf_1_dt}'
group by 1, 2;
