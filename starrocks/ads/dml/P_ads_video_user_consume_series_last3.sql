----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_video_user_consume_series_last3
-- workflow_version : 14
-- create_user      : chenmo
-- task_name        : ads_video_user_consume_series_last3
-- task_version     : 4
-- update_time      : 2024-12-05 11:16:54
-- sql_path         : \starrocks\tbl_ads_video_user_consume_series_last3\ads_video_user_consume_series_last3
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_video_user_consume_series_last3
select
    a.product_id,
    a.user_id,
    a.series_arr,
    a.remaining_epis_arr,
    now() as etl_time
from (
    select product_id, user_id,
           group_concat(series_id order by consume_value desc, create_time desc, series_id) as series_arr,
           group_concat(remaining_epis order by consume_value desc, create_time desc, series_id) as remaining_epis_arr
    from dws.dws_video_user_consume_series_last3_td
    where dt ='${dt}' and last_rn <= 3 group by product_id, user_id
) a
left join (
    select
        product_id, user_id, series_arr, remaining_epis_arr
    from ads.ads_video_user_consume_series_last3
) b on a.product_id = b.product_id and a.user_id = b.user_id
where b.series_arr is null or a.series_arr != b.series_arr or a.remaining_epis_arr != b.remaining_epis_arr;
