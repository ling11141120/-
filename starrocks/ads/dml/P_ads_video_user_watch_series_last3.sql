----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_video_user_watch_series_last3
-- workflow_version : 10
-- create_user      : chenmo
-- task_name        : ads_video_user_watch_series_last3
-- task_version     : 9
-- update_time      : 2024-12-04 19:01:06
-- sql_path         : \starrocks\tbl_ads_video_user_watch_series_last3\ads_video_user_watch_series_last3
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_video_user_watch_series_last3
select
    a.product_id,
    a.user_id,
    a.series_arr,
    now() as etl_time
from (
    select product_id, user_id, group_concat(series_id order by create_time desc, series_id) as series_arr
    from dws.dws_video_user_watch_series_last3_td
    where dt ='${dt}' group by product_id, user_id
) a
left join (
    select
        product_id, user_id, series_arr
    from ads.ads_video_user_watch_series_last3
) b on a.product_id = b.product_id and a.user_id = b.user_id
where b.series_arr is null or a.series_arr != b.series_arr;
