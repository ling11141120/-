----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_new_user_watch_series
-- workflow_version : 4
-- create_user      : chenmo
-- task_name        : ads_sv_new_user_watch_series
-- task_version     : 3
-- update_time      : 2025-08-04 18:56:31
-- sql_path         : \starrocks\tbl_ads_sv_new_user_watch_series\ads_sv_new_user_watch_series
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_new_user_watch_series
select
    a.dt,
    a.product_id,
    a.user_id,
    b.series_id,
    d.publish_edat,
    d.type_id,
    d.local_type,
    d.series_level,
    count(distinct b.epis_id) as epis_num,
    round(count(distinct b.epis_id)/d.last_epis*100, 0) as watch_progress,
    now() as etl_time
from (
    -- 近一天注册用户
    select
        dt,
        product_id,
        user_id
    from dim.dim_short_video_user_accountinfo
    where dt >= '${bf_1_dt}'
) a
-- 观看记录，观看时长大于0
left join dwd.dwd_video_short_video_epis_history b
on a.user_id = b.account_id and b.watch_stamp != 0
left join (
    -- 短剧维度信息
    select
        a.series_id,
        a.publish_edat,
        a.last_epis,
        ifnull(d.local_type, 2) as local_type,
        a.series_level,
        group_concat(distinct c.id order by c.id) as type_id
    from dim.dim_short_video_series_view a
    left join dim.dim_short_video_series_ref_type_view b
    on a.series_id = b.series_id
    left join dim.dim_short_video_series_type_view c
    on b.series_type_id = c.id
    left join dim.dim_short_video_source_series_view d
    on a.source_series_id = d.series_id
    group by a.series_id, a.publish_edat, a.last_epis, ifnull(d.local_type, 2), a.series_level
) d on b.series_id = d.series_id
left join dim.dim_short_video_epis_view e
on b.epis_id = e.epis_id
-- 过滤出观看进度占剧集长度80%以上的观看记录
where ifnull(b.watch_stamp/e.duration, 0) >= 0.8
group by a.dt, a.product_id, a.user_id, b.series_id, d.publish_edat, d.local_type, d.series_level, d.type_id, d.last_epis

;
