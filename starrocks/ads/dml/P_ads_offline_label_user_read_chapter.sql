----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_user_read_chapter
-- task_version     : 4
-- update_time      : 2025-01-22 11:36:21
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_user_read_chapter
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_offline_label_user_read_chapter
with a as (
    select
        product_id,
        user_id,
        bitmap_count(first_day_book_chapter) as start_day_read_chapters
    from  ads.ads_offline_label_user_readchapter_mid
),
b as (
    select
        product_id,
        user_id,
        total_read_chp_ids,
        total_read_bookids,
        total_read_days,
        new_chp_book_cnt,
        new_bookid_chapid
    from  dws.dws_read_user_read_roll_a
    where  dt = '${bf_1_dt}'
)
select  '${bf_1_dt}' as dt,
        a.product_id,
        a.user_id,
        0 as start_read_chapters,
        a.start_day_read_chapters,
        bitmap_count(b.total_read_chp_ids) as total_read_chp,
        bitmap_to_array(b.total_read_bookids) as total_read_bookid,
        bitmap_count(b.total_read_bookids) as total_read_books,
        b.total_read_days as total_read_days,
        b.new_chp_book_cnt as new_chp_book_cnt,
        b.new_bookid_chapid as new_chp_bookid_chpid,
        now() as etl_time
from a
left join b
on a.product_id = b.product_id
and a.user_id = b.user_id;
