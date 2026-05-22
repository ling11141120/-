----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : dws_read_user_readtime_roll_mid_history
-- workflow_version : 2
-- create_user      : linq
-- task_name        : dws_read_user_readtime_roll_mid
-- task_version     : 2
-- update_time      : 2023-10-26 17:30:56
-- sql_path         : \starrocks\dws_read_user_readtime_roll_mid_history\dws_read_user_readtime_roll_mid
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_user_readtime_roll_mid
select dt,product_id, user_id,sum(read_time_td) as read_time_td,now() as etl_time
from(
    select '${bf_1_dt}' as dt,product_id, user_id, read_time_td
    from dws.dws_read_user_readtime_roll_mid
    where dt='${bf_2_dt}'
    union all
    select dt,product_id, user_id,sum(read_times) as read_time
    from dws.dws_read_user_book_readtime_ed where dt='${bf_1_dt}'
    group by 1,2,3
)t1
group by 1,2,3;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_roll_a
-- workflow_version : 27
-- create_user      : linq
-- task_name        : dws_read_user_readtime_roll_mid
-- task_version     : 11
-- update_time      : 2025-06-16 16:24:21
-- sql_path         : \starrocks\tbl_dws_read_user_read_roll_a\dws_read_user_readtime_roll_mid
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_user_readtime_roll_mid
with tmp_a AS (
    select '${bf_15_dt}' as dt,
           product_id,
           user_id,
           read_day_td,
           read_time_td
    from dws.dws_read_user_readtime_roll_mid
    where dt='${bf_16_dt}'
),
     tmp_b AS (
         select dt,
                product_id,
                user_id,
                1 as read_day_td,
                sum(read_times) as read_time_td
         from dws.dws_read_user_book_readtime_ed
         where dt = '${bf_15_dt}' and product_id !=-1
group by 1,2,3
    )
select
    '${bf_15_dt}' as dt,
    COALESCE(a.product_id, b.product_id) AS product_id,
    COALESCE(a.user_id, b.user_id) AS user_id,
    COALESCE(a.read_day_td, 0) + COALESCE(b.read_day_td, 0) AS read_day_td,
    COALESCE(a.read_time_td, 0) + COALESCE(b.read_time_td, 0) AS read_time_td,
    NOW() AS etl_time
from tmp_a a
         FULL OUTER JOIN tmp_b b
                         ON a.product_id = b.product_id
                             AND a.user_id = b.user_id;
