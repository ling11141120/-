----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_read_user_read_book_l90d
-- workflow_version : 1
-- create_user      : yanxh
-- task_name        : dwm_read_user_read_book_l90d
-- task_version     : 1
-- update_time      : 2024-03-05 13:58:22
-- sql_path         : \starrocks\tbl_dwm_read_user_read_book_l90d\dwm_read_user_read_book_l90d
----------------------------------------------------------------
-- SQL语句
insert into  dwm.dwm_read_user_read_book_l90d
-- 东八区转西五区--------------------
select  '${dt}' as dt,product_id,user_id,book_id,max(hours_add(create_time,-13)) as lst_read_tm,now() as etl_tm
from   dwd.dwd_read_user_chapter_view
where
dt>= date_sub(hours_add('${dt}', 13),interval 90 day)  and
create_time >= date_sub(hours_add('${dt}', 13),interval 90 day)
 and create_time <hours_add('${dt}', 13)
 and user_id >0 and book_id >0
 group by 1,2,3,4;
