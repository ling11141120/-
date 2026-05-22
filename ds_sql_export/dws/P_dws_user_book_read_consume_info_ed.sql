----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_book_read_consume_info_ed
-- workflow_version : 27
-- create_user      : yanxh
-- task_name        : dws_user_book_read_consume_info_ed
-- task_version     : 2
-- update_time      : 2025-06-17 15:58:47
-- sql_path         : \starrocks\tbl_dws_user_book_read_consume_info_ed\dws_user_book_read_consume_info_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_book_read_consume_info_ed
with tmp_1 AS (
    select user_id, book_id, product_id
    from  dws.dws_read_user_read_book_info_ed
    where dt ='${bf_1_dt}'
      and product_id in (3311,3333,3371,3399,3501,3511,7757,8858,3322,3366,3388)
    group by 1,2,3
),
tmp_2 AS (
    select  user_id,
            book_id,
            product_id,
            sum(ifnull(con_chapter_num,0)) con_chapter_num,
            sum(ifnull(csum_total_amount,0))  as  csum_total_amount
    from dws.dws_consume_user_consume_mid
    where dt='${bf_1_dt}' and product_id in (3311,3333,3371,3399,3501,3511,7757,8858,3322,3366,3388)
    group by 1,2,3
),
tmp_3 AS (
    select a.user_id,
           a.book_id,
           a.product_id,
           case when b.user_id is not null then 1 else 0 end as is_read,
           max(ifnull(a.max_serial_number,0))  max_serial_number,
           sum(ifnull(a.read_chpts,0)) read_chpts
    from dws.dws_read_user_read_book_info_mid a
             left join  tmp_1 b
                        on a.user_id=b.user_id and a.book_id=b.book_id  and a.product_id=b.product_id
    where   a.dt='${bf_1_dt}' and a.product_id in (3311,3333,3371,3399,3501,3511,7757,8858,3322,3366,3388)
    group by 1,2,3 ,4
)
select
    '${dt}' as dt,
    x1.product_id,
    x1.user_id,
    x1.book_id,
    CASE
        WHEN max_serial_number=-1 THEN read_chpts
        ELSE max_serial_number
    END AS  max_serial_number,
    x1.read_chpts,
    coalesce(x2.con_chapter_num, 0) con_chapter_num,
    coalesce(x2.csum_total_amount, 0) csum_total_amount,x1.is_read,
    now() as etl_time
from tmp_3 x1
         left join tmp_2 x2
             on x1.user_id=x2.user_id and x1.book_id=x2.book_id and x1.product_id=x2.product_id;
