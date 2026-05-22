----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_user_readtime_book_bitmap_mid
-- task_version     : 12
-- update_time      : 2025-03-08 07:17:08
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_user_readtime_book_bitmap_mid
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_offline_label_user_readtime_book_bitmap_mid
select  product_id,user_id,
        bitmap_union(to_bitmap(book_id)) as more_onem_total_read_bookid_bitmap,
        now() as etl_time
from ads.ads_offline_label_user_readtime_mid
where dt = '${bf_1_dt}'  and  book_read_times > 60
group by 1,2;
