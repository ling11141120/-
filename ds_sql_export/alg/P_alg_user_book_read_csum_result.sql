----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_user_book_read_csum_result
-- workflow_version : 5
-- create_user      : yanxh
-- task_name        : tbl_alg_user_book_read_csum_result
-- task_version     : 5
-- update_time      : 2025-03-24 21:34:35
-- sql_path         : \starrocks\tbl_alg_user_book_read_csum_result\tbl_alg_user_book_read_csum_result
----------------------------------------------------------------
-- SQL语句
INSERT INTO alg.alg_user_book_read_csum_result
WITH data_tmp AS (
    select
        x1.user_id,
        x1.book_id,
        x1.read_chpts,
        x1.csum_total_amount,
        row_number() over(partition by x1.user_id order by	x1.csum_total_amount desc,	read_chpts desc ) indexs
    from  dws.dws_user_book_read_consume_info_ed x1
    where x1.dt = '${dt}'
)
select
    '${dt}' as dt,
    1 as  product_id ,
    concat('nv',  user_id) user_id,
    'readcsum' as redis_key,
    array_join( array_agg(concat(book_id,':',read_chpts, ':', cast(csum_total_amount as int))),',') books
from  data_tmp zz
where indexs<=10
group by 1 ,2,3,4;
