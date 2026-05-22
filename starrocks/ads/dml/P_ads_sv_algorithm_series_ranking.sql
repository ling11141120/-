----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_algorithm_series_ranking
-- workflow_version : 1
-- create_user      : chenmo
-- task_name        : ads_sv_algorithm_series_ranking
-- task_version     : 1
-- update_time      : 2026-02-16 12:06:56
-- sql_path         : \starrocks\tbl_ads_sv_algorithm_series_ranking\ads_sv_algorithm_series_ranking
----------------------------------------------------------------
-- SQL语句
-- =====================================================================================
-- 数据清洗SQL
-- =====================================================================================

-- ========== 总榜（days=1）==========
insert into ads.ads_sv_algorithm_series_ranking
with watch_data as (
    -- 第一步：统计观看数据（按剧集+core）
    select
        b.series_id,
        a.corever2 as core,
        count(distinct a.user_id) as uv,
        count(distinct concat(a.user_id, '_', b.epis_id)) as total_epis_cnt
    from dim.dim_short_video_user_accountinfo a
    inner join (
        select
            account_id,
            series_id,
            epis_id
        from dwd.dwd_video_short_video_epis_history
        where dt <= '${bf_1_dt}'
            and watch_stamp > 5  -- 有效观看
        group by account_id, series_id, epis_id
    ) b on a.user_id = b.account_id
    where a.dt = '${bf_1_dt}'
    group by b.series_id, a.corever2
)
-- 第二步：从剧集表炸裂core，然后关联观看数据并计算排名
select
    '${bf_1_dt}' as dt,
    1 as days,
    a.series_id,
    c.core as core,
    a.language as lang_id,
    if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) as avg_epis,
    ifnull(b.uv, 0) as uv,
    a.publish_edat,
    row_number() over(partition by a.language, c.core order by
        if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) desc) as avg_epis_rank,
    row_number() over(partition by a.language, c.core order by ifnull(b.uv, 0) desc) as uv_rank,
    row_number() over(partition by a.language, c.core order by a.publish_edat desc) as publish_edat_rank,
    now() as etl_time
from dim.dim_short_video_series_view a
cross join unnest(split(if(a.core = '' or a.core is null, '1,2,3,4,15,16,17', a.core), ',')) as c(core)
left join watch_data b
    on a.series_id = b.series_id
    and c.core = b.core
where a.publish_status = 1
    and a.is_delete = 0
    and date(a.publish_edat) <= '${bf_1_dt}'
    and a.last_epis != 0;

-- SQL语句
-- ========== 一日榜（days=2）==========
insert into ads.ads_sv_algorithm_series_ranking
with watch_data as (
    select
        b.series_id,
        a.corever2 as core,
        count(distinct a.user_id) as uv,
        count(distinct concat(a.user_id, '_', b.epis_id)) as total_epis_cnt
    from dim.dim_short_video_user_accountinfo a
    inner join (
        select
            account_id,
            series_id,
            epis_id
        from dwd.dwd_video_short_video_epis_history
        where dt = '${bf_1_dt}'
            and watch_stamp > 5
        group by account_id, series_id, epis_id
    ) b on a.user_id = b.account_id
    where a.dt = '${bf_1_dt}'
    group by b.series_id, a.corever2
)
select
    '${bf_1_dt}' as dt,
    2 as days,
    a.series_id,
    c.core as core,
    a.language as lang_id,
    if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) as avg_epis,
    ifnull(b.uv, 0) as uv,
    a.publish_edat,
    row_number() over(partition by a.language, c.core order by
        if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) desc) as avg_epis_rank,
    row_number() over(partition by a.language, c.core order by ifnull(b.uv, 0) desc) as uv_rank,
    row_number() over(partition by a.language, c.core order by a.publish_edat desc) as publish_edat_rank,
    now() as etl_time
from dim.dim_short_video_series_view a
cross join unnest(split(if(a.core = '' or a.core is null, '1,2,3,4,15,16,17', a.core), ',')) as c(core)
left join watch_data b
    on a.series_id = b.series_id
    and c.core = b.core
where a.publish_status = 1
    and a.is_delete = 0
    and date(a.publish_edat) = '${bf_1_dt}'
    and a.last_epis != 0;

-- SQL语句
-- ========== 三日榜（days=3）==========
insert into ads.ads_sv_algorithm_series_ranking
with watch_data as (
    select
        b.series_id,
        a.corever2 as core,
        count(distinct a.user_id) as uv,
        count(distinct concat(a.user_id, '_', b.epis_id)) as total_epis_cnt
    from dim.dim_short_video_user_accountinfo a
    inner join (
        select
            account_id,
            series_id,
            epis_id
        from dwd.dwd_video_short_video_epis_history
        where dt >= date_sub('${bf_1_dt}', interval 2 day)
            and dt <= '${bf_1_dt}'
            and watch_stamp > 5
        group by account_id, series_id, epis_id
    ) b on a.user_id = b.account_id
    where a.dt = '${bf_1_dt}'
    group by b.series_id, a.corever2
)
select
    '${bf_1_dt}' as dt,
    3 as days,
    a.series_id,
    c.core as core,
    a.language as lang_id,
    if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) as avg_epis,
    ifnull(b.uv, 0) as uv,
    a.publish_edat,
    row_number() over(partition by a.language, c.core order by
        if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) desc) as avg_epis_rank,
    row_number() over(partition by a.language, c.core order by ifnull(b.uv, 0) desc) as uv_rank,
    row_number() over(partition by a.language, c.core order by a.publish_edat desc) as publish_edat_rank,
    now() as etl_time
from dim.dim_short_video_series_view a
cross join unnest(split(if(a.core = '' or a.core is null, '1,2,3,4,15,16,17', a.core), ',')) as c(core)
left join watch_data b
    on a.series_id = b.series_id
    and c.core = b.core
where a.publish_status = 1
    and a.is_delete = 0
    and date(a.publish_edat) >= date_sub('${bf_1_dt}', interval 2 day)
    and date(a.publish_edat) <= '${bf_1_dt}'
    and a.last_epis != 0;

-- SQL语句
-- ========== 七日榜（days=4）==========
insert into ads.ads_sv_algorithm_series_ranking
with watch_data as (
    select
        b.series_id,
        a.corever2 as core,
        count(distinct a.user_id) as uv,
        count(distinct concat(a.user_id, '_', b.epis_id)) as total_epis_cnt
    from dim.dim_short_video_user_accountinfo a
    inner join (
        select
            account_id,
            series_id,
            epis_id
        from dwd.dwd_video_short_video_epis_history
        where dt >= date_sub('${bf_1_dt}', interval 6 day)
            and dt <= '${bf_1_dt}'
            and watch_stamp > 5
        group by account_id, series_id, epis_id
    ) b on a.user_id = b.account_id
    where a.dt = '${bf_1_dt}'
    group by b.series_id, a.corever2
)
select
    '${bf_1_dt}' as dt,
    4 as days,
    a.series_id,
    c.core as core,
    a.language as lang_id,
    if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) as avg_epis,
    ifnull(b.uv, 0) as uv,
    a.publish_edat,
    row_number() over(partition by a.language, c.core order by
        if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) desc) as avg_epis_rank,
    row_number() over(partition by a.language, c.core order by ifnull(b.uv, 0) desc) as uv_rank,
    row_number() over(partition by a.language, c.core order by a.publish_edat desc) as publish_edat_rank,
    now() as etl_time
from dim.dim_short_video_series_view a
cross join unnest(split(if(a.core = '' or a.core is null, '1,2,3,4,15,16,17', a.core), ',')) as c(core)
left join watch_data b
    on a.series_id = b.series_id
    and c.core = b.core
where a.publish_status = 1
    and a.is_delete = 0
    and date(a.publish_edat) >= date_sub('${bf_1_dt}', interval 6 day)
    and date(a.publish_edat) <= '${bf_1_dt}'
    and a.last_epis != 0;

-- SQL语句
-- ========== 十五日榜（days=5）==========
insert into ads.ads_sv_algorithm_series_ranking
with watch_data as (
    select
        b.series_id,
        a.corever2 as core,
        count(distinct a.user_id) as uv,
        count(distinct concat(a.user_id, '_', b.epis_id)) as total_epis_cnt
    from dim.dim_short_video_user_accountinfo a
    inner join (
        select
            account_id,
            series_id,
            epis_id
        from dwd.dwd_video_short_video_epis_history
        where dt >= date_sub('${bf_1_dt}', interval 14 day)
            and dt <= '${bf_1_dt}'
            and watch_stamp > 5
        group by account_id, series_id, epis_id
    ) b on a.user_id = b.account_id
    where a.dt = '${bf_1_dt}'
    group by b.series_id, a.corever2
)
select
    '${bf_1_dt}' as dt,
    5 as days,
    a.series_id,
    c.core as core,
    a.language as lang_id,
    if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) as avg_epis,
    ifnull(b.uv, 0) as uv,
    a.publish_edat,
    row_number() over(partition by a.language, c.core order by
        if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) desc) as avg_epis_rank,
    row_number() over(partition by a.language, c.core order by ifnull(b.uv, 0) desc) as uv_rank,
    row_number() over(partition by a.language, c.core order by a.publish_edat desc) as publish_edat_rank,
    now() as etl_time
from dim.dim_short_video_series_view a
cross join unnest(split(if(a.core = '' or a.core is null, '1,2,3,4,15,16,17', a.core), ',')) as c(core)
left join watch_data b
    on a.series_id = b.series_id
    and c.core = b.core
where a.publish_status = 1
    and a.is_delete = 0
    and date(a.publish_edat) >= date_sub('${bf_1_dt}', interval 14 day)
    and date(a.publish_edat) <= '${bf_1_dt}'
    and a.last_epis != 0;

-- SQL语句
-- ========== 三十日榜（days=6）==========
insert into ads.ads_sv_algorithm_series_ranking
with watch_data as (
    select
        b.series_id,
        a.corever2 as core,
        count(distinct a.user_id) as uv,
        count(distinct concat(a.user_id, '_', b.epis_id)) as total_epis_cnt
    from dim.dim_short_video_user_accountinfo a
    inner join (
        select
            account_id,
            series_id,
            epis_id
        from dwd.dwd_video_short_video_epis_history
        where dt >= date_sub('${bf_1_dt}', interval 29 day)
            and dt <= '${bf_1_dt}'
            and watch_stamp > 5
        group by account_id, series_id, epis_id
    ) b on a.user_id = b.account_id
    where a.dt = '${bf_1_dt}'
    group by b.series_id, a.corever2
)
select
    '${bf_1_dt}' as dt,
    6 as days,
    a.series_id,
    c.core as core,
    a.language as lang_id,
    if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) as avg_epis,
    ifnull(b.uv, 0) as uv,
    a.publish_edat,
    row_number() over(partition by a.language, c.core order by
        if(ifnull(b.uv, 0) > 0, round(ifnull(b.total_epis_cnt, 0) / b.uv, 2), 0) desc) as avg_epis_rank,
    row_number() over(partition by a.language, c.core order by ifnull(b.uv, 0) desc) as uv_rank,
    row_number() over(partition by a.language, c.core order by a.publish_edat desc) as publish_edat_rank,
    now() as etl_time
from dim.dim_short_video_series_view a
cross join unnest(split(if(a.core = '' or a.core is null, '1,2,3,4,15,16,17', a.core), ',')) as c(core)
left join watch_data b
    on a.series_id = b.series_id
    and c.core = b.core
where a.publish_status = 1
    and a.is_delete = 0
    and date(a.publish_edat) >= date_sub('${bf_1_dt}', interval 29 day)
    and date(a.publish_edat) <= '${bf_1_dt}'
    and a.last_epis != 0;
