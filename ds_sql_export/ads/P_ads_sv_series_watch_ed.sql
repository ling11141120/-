----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_series_watch_ed
-- workflow_version : 31
-- create_user      : chenmo
-- task_name        : ads_sv_series_watch_ed
-- task_version     : 15
-- update_time      : 2025-04-27 15:31:41
-- sql_path         : \starrocks\tbl_ads_sv_series_watch_ed\ads_sv_series_watch_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_sv_series_watch_ed` where dt = '${bf_1_dt}';

-- SQL语句
-- |||process_name=tbl_ads_sv_series_watch_ed|||
insert into ads.ads_sv_series_watch_ed
with a as (
    select
        story_code,
        coop_begin_time,
        coop_end_time
    from dim.dim_sr_cp_story_view
    where coop_type = 2
    and story_type = 2
    and divide_type = 1
),
b as (
    select
        series_id,
        language,
        source_series_code
    from dim.dim_sv_series_hi
),
c as (
    select
        *
    from ods.ods_tidb_short_video_log_ext_epis_watch_log_part2
    where dt = '${bf_1_dt}'
)
select
    dt,
    series_code,
    lang_id,
    sum(play_count) as play_count,
    now() as etl_tm
from (
    select
        c.dt,
        a.story_code as series_code,
        b.language as lang_id,
        1 as play_count
    from a
    join b on a.story_code = b.source_series_code
    join c on b.series_id = c.series_id and b.language = c.lang_id and c.create_time >= a.coop_begin_time and c.create_time <= a.coop_end_time
    union all
    select
        '${bf_1_dt}' as dt,
        series_code,
        lang_id,
        play_count
    from ads.ads_sv_series_watch_ed
    where dt = '${bf_2_dt}'
) t
group by dt, series_code, lang_id;
