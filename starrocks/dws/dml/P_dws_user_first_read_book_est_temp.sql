----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_first_read_book_est_ed
-- workflow_version : 18
-- create_user      : yanxh
-- task_name        : dws_user_first_read_book_est_temp
-- task_version     : 5
-- update_time      : 2026-02-28 10:56:25
-- sql_path         : \starrocks\tbl_dws_user_first_read_book_est_ed\dws_user_first_read_book_est_temp
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_user_first_read_book_est_temp where dt>='${bf_2_dt}' and dt<='${dt}';

-- SQL语句
insert into dws.dws_user_first_read_book_est_temp
 -- ---------将首次阅读的东八区表转换为西五区表 ---------------------------------
 select  date(hours_add(a.fst_read_tm,-13)) as dt,a.product_id,a.user_id,a.book_id,
        hours_add(a.fst_read_tm,-13) as fst_read_tm,
        hours_add(hours_add(a.fst_read_tm,-13),12) as h12_time,
        hours_add(hours_add(a.fst_read_tm,-13),24) as h24_time,
        hours_add(hours_add(a.fst_read_tm,-13),72) as d3_time,
        hours_add(hours_add(a.fst_read_tm,-13),168) as d7_time,
        hours_add(hours_add(a.fst_read_tm,-13),720) as d30_time,
        now() as etl_tm
 from
 dwm.dwm_user_first_read_book_info_ed a
 where fst_read_tm>=hours_add('${bf_2_dt}',13) and fst_read_tm<hours_add('${dt}',13);
