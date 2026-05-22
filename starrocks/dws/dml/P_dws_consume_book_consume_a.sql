----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_book_consume_a
-- workflow_version : 6
-- create_user      : linq
-- task_name        : dws_consume_book_consume_a
-- task_version     : 6
-- update_time      : 2023-11-15 16:01:24
-- sql_path         : \starrocks\tbl_dws_consume_book_consume_a\dws_consume_book_consume_a
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_consume_book_consume_a where dt >= '${dt}';

-- SQL语句
insert into dws.dws_consume_book_consume_a
select dt, types, book_id, site_id, sum(consume_td) ,now() as etl_time
from (
         select '${dt}' as dt, types, book_id, site_id, consume_td
         from dws.dws_consume_book_consume_a
         where dt = date_sub('${dt}', interval 1 day)
         union all
         select '${dt}' as dt, types, book_id, site_id, sum(amount) as consume_td
         from dws.dws_consume_book_consume_ed
         where dt = date_sub('${dt}', interval 1 day)
         group by types, book_id, site_id
     )t1
group by dt,types,book_id,site_id;
