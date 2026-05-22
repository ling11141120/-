----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_roll_a
-- workflow_version : 27
-- create_user      : linq
-- task_name        : dws_read_user_readtime_a_mid
-- task_version     : 9
-- update_time      : 2025-05-28 18:38:09
-- sql_path         : \starrocks\tbl_dws_read_user_read_roll_a\dws_read_user_readtime_a_mid
----------------------------------------------------------------
-- SQL语句
INSERT OVERWRITE dws.dws_read_user_readtime_a_mid
select product_id, user_id, sum(read_day_td) as read_day_td, sum(read_time_td) as read_time_td,now() as etl_time
from(
    select product_id, user_id, read_day_td, read_time_td
    from dws.dws_read_user_readtime_roll_mid
    where dt='${bf_15_dt}'
    union all
    select product_id, user_id, count(distinct dt) as read_day_td, sum(read_times) as read_time
    from dws.dws_read_user_book_readtime_ed
    where dt>='${bf_14_dt}' and dt<'${dt}' and product_id !=-1
    group by 1,2
)t1
group by 1,2;
