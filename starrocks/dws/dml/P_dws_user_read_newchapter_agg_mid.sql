----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_read_newchapter_agg_mid
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : dws_user_read_newchapter_agg_mid
-- task_version     : 1
-- update_time      : 2025-06-19 17:08:30
-- sql_path         : \starrocks\tbl_dws_user_read_newchapter_agg_mid\dws_user_read_newchapter_agg_mid
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_read_newchapter_agg_mid
with read_info as (
    select user_id, product_id, book_id, chapter_id
    from (
             select  user_id, product_id,book_id, chapter_id
             from dwd.dwd_read_user_chapter_view where dt = '${bf_1_dt}'
         ) read_t1
    group by user_id, product_id, book_id, chapter_id
),
     chapter as (
         select book_id,site_id,chapter_id,serial_number from dim.dim_book_chapter_info
     ),
     newRead as (
         select user_id, product_id, book_id,serial_number
         from (
                  select user_id,product_id,read_info.book_id,serial_number,
                         row_number() over (partition by user_id,product_id,read_info.book_id order by serial_number desc) rk
                  from read_info
                  left join chapter on read_info.book_id = chapter.book_id and read_info.chapter_id = chapter.chapter_id
              ) newRead_t1
         where rk = 1
     )
select  product_id,user_id, book_id, serial_number,now() as etl_time
from newRead;
