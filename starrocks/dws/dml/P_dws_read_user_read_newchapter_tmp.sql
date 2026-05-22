----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_roll_a
-- workflow_version : 27
-- create_user      : linq
-- task_name        : dws_read_user_read_newchapter_tmp
-- task_version     : 4
-- update_time      : 2025-06-16 17:43:12
-- sql_path         : \starrocks\tbl_dws_read_user_read_roll_a\dws_read_user_read_newchapter_tmp
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_read_user_read_newchapter_tmp
with tmp_a AS (
       select book_id, chapter_id,serial_number
             from (
                      select book_id,
                             chapter_id,
                             serial_number,
                             row_number() over (partition by book_id order by serial_number desc,chapter_id desc) rk
                      from dim.dim_book_chapter_info
                  ) new_chp_a
             where rk = 1
),

tmp_c AS (
       select user_id, product_id, mid.book_id as book_id, new_chp_b.chapter_id as chapter_id
         from (
                  select user_id,product_id,book_id,serial_number
                  from dws.dws_user_read_newchapter_agg_mid mid
              )mid
         inner join tmp_a new_chp_b
            on mid.book_id = new_chp_b.book_id
                   and mid.serial_number = new_chp_b.serial_number
)

select product_id,
       user_id,
       array_agg(concat_ws('_',book_id,chapter_id)) as new_bookid_chapid,
       count(distinct book_id) as new_chp_book_cnt,
       now() as etl_time
from tmp_c new_chp_c
group by 1,2;
