----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_user_readchapter_mid
-- task_version     : 5
-- update_time      : 2025-08-15 18:51:28
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_user_readchapter_mid
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_offline_label_user_readchapter_mid
select  product_id,user_id,first_day_book_chapter,now() as etl_time
from
(   select  product_id,user_id,first_day_book_chapter,
            row_number() over (partition by product_id,user_id order by dt) as rn
    from
        (   select  product_id,user_id, first_day_book_chapter,'${bf_2_dt}' as dt
            from ads.ads_offline_label_user_readchapter_mid
            union all
            select product_id,user_id,bitmap_union(to_bitmap(concat(book_id,chapter_id))) as first_day_book_chapter,dt
            from dwd.dwd_read_user_chapter_view
            where dt = '${bf_1_dt}'
            group by 1,2,4
            ) a
    ) a
where rn = 1
and bitmap_count(first_day_book_chapter) > 0
;
