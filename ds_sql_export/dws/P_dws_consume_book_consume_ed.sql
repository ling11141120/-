----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_book_consume_ed
-- workflow_version : 2
-- create_user      : admin
-- task_name        : dws_consume_book_consume_ed
-- task_version     : 2
-- update_time      : 2023-10-27 13:38:11
-- sql_path         : \starrocks\tbl_dws_consume_book_consume_ed\dws_consume_book_consume_ed
----------------------------------------------------------------
-- SQL语句
delete from dws.dws_consume_book_consume_ed where dt>='${bf_1_dt}' and dt<='${dt}';

-- SQL语句
insert into dws.dws_consume_book_consume_ed
select dt,types,book_id,site_id,round(sum(con_chp_amount)) as consume ,now() as etl_time
from dwm.dwm_consume_user_consume_mild_ed
where dt>='${bf_1_dt}' and dt<='${dt}'
group by 1, 2, 3, 4;
