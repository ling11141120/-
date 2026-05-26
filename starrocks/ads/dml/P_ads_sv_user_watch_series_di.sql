----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_user_watch_series_di
-- workflow_version : 9
-- create_user      : linq
-- task_name        : ads_sv_user_watch_series_di
-- task_version     : 3
-- update_time      : 2024-04-10 18:15:19
-- sql_path         : \starrocks\tbl_ads_sv_user_watch_series_di\ads_sv_user_watch_series_di
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_user_watch_series_di
select a.user_id,bitmap_to_string(a.watch_series_td) as watch_series_td,now() as etl_time,now() as row_update_time
from ads.ads_wide_short_video_user_info_a a
join (
    select account_id as user_id
    from dwd.dwd_video_short_video_epis_history
    where dt='${bf_1_dt}'
    group by 1
    )b on a.user_id=b.user_id
where dt='${bf_1_dt}' and product_id=6833;
