----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_video_user_watch_time_series_last3_td
-- workflow_version : 8
-- create_user      : chenmo
-- task_name        : dws_video_user_watch_time_series_last3_td
-- task_version     : 7
-- update_time      : 2025-01-27 15:48:46
-- sql_path         : \starrocks\tbl_dws_video_user_watch_time_series_last3_td\dws_video_user_watch_time_series_last3_td
----------------------------------------------------------------
-- SQL语句
insert into dws.`dws_video_user_watch_time_series_last3_td`
with user_series as (
    select
        user_id,
        series_id,
        sum(WatchStamp) as watch_stamp,
        max(CreateTime) as create_time
    from (
        select
            a.AccountId as user_id,
            a.SeriesId as series_id,
            if(a.WatchOver = 1, ifnull(b.duration, a.WatchStamp), a.WatchStamp) as WatchStamp,
            a.CreateTime
        from ods.ods_tidb_short_video_log_ext_epis_history_part2 a
        left join dim.dim_short_video_epis_view b on a.EpisId = b.epis_id
        where a.dt = '${dt}' and if(a.WatchOver = 1, ifnull(b.duration, a.WatchStamp), a.WatchStamp) != 0
        union all
        select
            user_id,
            series_id,
            watch_stamp,
            create_time
        from dws.dws_video_user_watch_time_series_last3_td
        where dt = '${bf_1_dt}'
    ) t
    group by user_id, series_id
)
select
    '${dt}' as dt,
    6833 as product_id,
    user_id,
    last_rn,
    series_id,
    watch_stamp,
    create_time,
    now() as etl_tm
from (
    select
        user_id,
        series_id,
        watch_stamp,
        create_time,
        row_number() over (partition by user_id order by watch_stamp desc, create_time desc, series_id) as last_rn
    from user_series
) a;
