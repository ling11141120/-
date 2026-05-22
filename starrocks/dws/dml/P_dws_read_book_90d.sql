----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_book_90d
-- workflow_version : 2
-- create_user      : linq
-- task_name        : dws_read_book_90d
-- task_version     : 2
-- update_time      : 2023-10-26 16:54:35
-- sql_path         : \starrocks\tbl_dws_read_book_90d\dws_read_book_90d
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_book_90d
select '${dt}' as dt, site_id, book_id, bitmap_union(to_bitmap(user_id)) as read_user_90d,
now() as etl_time
from dws.dws_read_user_readbook_ed
where dt >= date_sub('${dt}', interval 90 day)
  and dt < '${dt}'
group by site_id, book_id;
