----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_user_read_time
-- task_version     : 5
-- update_time      : 2024-10-16 11:25:04
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_user_read_time
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_offline_label_user_read_time
select  '${bf_1_dt}' as dt,a.product_id,a.user_id,0 as start_read_time,b.start_day_read_time,
        a.read_time_td as total_read_time,
        bitmap_to_array(c.more_onem_total_read_bookid_bitmap) as more_onem_total_read_bookid,
        bitmap_count(c.more_onem_total_read_bookid_bitmap) as more_onem_total_read_books,
        a.read_time_td,
        now() as etl_time
from dws.dws_read_user_readtime_a_mid a
left join ads.ads_offline_label_user_firstday_readtime_mid b
on a.product_id = b.product_id and a.user_id = b.user_id
left join ads.ads_offline_label_user_readtime_book_bitmap_mid c
on a.product_id = c.product_id and a.user_id = c.user_id;
