----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_video_user_watch_series_last3_td
-- workflow_version : 7
-- create_user      : chenmo
-- task_name        : dws_video_user_watch_series_last3_td
-- task_version     : 7
-- update_time      : 2024-11-05 21:06:08
-- sql_path         : \starrocks\tbl_dws_video_user_watch_series_last3_td\dws_video_user_watch_series_last3_td
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.`dws_video_user_watch_series_last3_td` where dt = '${dt}';

-- SQL语句
insert into dws.`dws_video_user_watch_series_last3_td`
with user_series as (
    select
        user_id,
        series_id,
        max(CreateTime) as create_time
    from (
        select
            AccountId as user_id,
            SeriesId as series_id,
            CreateTime
        from ods.ods_tidb_short_video_log_ext_epis_history_part2
        where dt = '${dt}'
        union all
        select
            user_id,
            series_id,
            create_time
        from dws.dws_video_user_watch_series_last3_td
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
    create_time,
    now() as etl_tm
from (
    select
        user_id,
        series_id,
        create_time,
        row_number() over (partition by user_id order by create_time desc) as last_rn
    from user_series
) a where last_rn <= 3;
