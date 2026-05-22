----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_userfist_lastmarket_sensors_a
-- task_version     : 6
-- update_time      : 2023-12-21 10:25:47
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_userfist_lastmarket_sensors_a
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_userfist_lastmarket_sensors_a
select date_sub(CURRENT_DATE(),interval 1 day ) dt, user_id, first_media_name, last_media_name, first_book, last_book, first_currentlanguage2, last_currentlanguage2, NOW() from (
select user_id,
-- 首次媒体 最新媒体
FIRST_VALUE(source)over(partition by user_id order by install_date asc rows between unbounded preceding and unbounded following) first_media_name,
FIRST_VALUE(source)over(partition by user_id order by install_date desc rows between unbounded preceding and unbounded following) last_media_name,
-- 首次书籍 最新书籍
FIRST_VALUE(book_id)over(partition by user_id order by install_date asc rows between unbounded preceding and unbounded following) first_book,
FIRST_VALUE(book_id)over(partition by user_id order by install_date desc rows between unbounded preceding and unbounded following) last_book,
-- 首次推广语言 最新推广语言
FIRST_VALUE(current_language2)over(partition by user_id order by install_date asc rows between unbounded preceding and unbounded following) first_currentlanguage2,
FIRST_VALUE(current_language2)over(partition by user_id order by install_date desc rows between unbounded preceding and unbounded following) last_currentlanguage2,
ROW_NUMBER() over (partition by user_id order by install_date desc) n
from dwd.dwd_user_install_info_ed_view where Product_Id !='6883' and user_id !=-1)a where n =1;
