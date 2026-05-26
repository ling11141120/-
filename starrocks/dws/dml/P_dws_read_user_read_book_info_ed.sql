----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_book_info_ed
-- workflow_version : 5
-- create_user      : yanxh
-- task_name        : tbl_dws_read_user_read_book_info_ed
-- task_version     : 4
-- update_time      : 2025-05-30 18:18:17
-- sql_path         : \starrocks\tbl_dws_read_user_read_book_info_ed\tbl_dws_read_user_read_book_info_ed
----------------------------------------------------------------
-- SQL语句
INSERT overwrite dws.dws_read_user_read_book_info_ed  partition(p'${pname}')
select
 dt,
 product_id,
 user_id,
 site_id,
 book_id,
 IFNULL(book_name, '-') book_name,
 mt,
 corever,
 current_language,
 current_language2,
 count(distinct  chapter_id) as read_chpts,
 sum(read_counts) read_counts,
  min(IFNULL(serial_number, 999999999) ) min_serial_number,
  max(IFNULL(serial_number, -1) ) max_serial_number,
  now() as etl_time
  from
 dws.dws_read_user_read_book_chapter_info_ed
 where  dt ='${bf_1_dt}'
 group by   1 ,2,3,4,5,6,7,8,9,10;
