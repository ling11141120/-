----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_automation_new_series_ranking_est
-- workflow_version : 15
-- create_user      : chenmo
-- task_name        : ads_sv_automation_new_series_ranking_est
-- task_version     : 12
-- update_time      : 2025-06-27 19:02:49
-- sql_path         : \starrocks\tbl_ads_sv_automation_new_series_ranking_est\ads_sv_automation_new_series_ranking_est
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_automation_new_series_ranking_est
with series as (
    select
        SeriesId,
        LangId,
        date(date_sub(RecommendStartTime, interval 13 hour)) as start_date,
        date(date_sub(StatisticTime, interval 37 hour)) as end_date
    from ods.ods_short_video_admin_center_climb_series_plan
    where date(date_sub(StatisticTime, interval 13 hour)) = '${dt}'
)
select
    a.start_date,
    a.end_date,
    a.SeriesId,
    a.LangId,
    sum(ifnull(b.watch_num, 0)) as watch_num,
    sum(ifnull(c.consume_num, 0)) as consume_num,
    sum(ifnull(c.consume_amt, 0)) as consume_amt,
    sum(ifnull(d.exposure_num, 0)) as exposure_num,
    now() as etl_time
from series a
left join (
    -- 观看人数
    select
        a.series_id,
        count(distinct account_id) as watch_num
    from dwd.dwd_video_short_video_epis_history a
    left join dim.dim_short_video_user_accountinfo b
    on a.account_id = b.user_id
    left join series c
    on a.series_id = c.SeriesId and c.start_date <= a.dt and c.end_date >= a.dt
    where b.corever = 1 and date(date_sub(a.create_time, interval 13 hour)) >= '${bf_6_dt}' and date(date_sub(a.create_time, interval 13 hour)) <= '${bf_1_dt}'
    group by a.series_id
) b on a.SeriesId = b.series_id
left join (
    -- 观看币消耗
    select
        series_id,
        count(distinct account_id) as consume_num,
        sum(consume_value) as consume_amt
    from dwd.dwd_sv_consume_user_consume_bill_pdi a
    left join dim.dim_short_video_user_accountinfo b
    on a.account_id = b.user_id
    left join series c
    on a.series_id = c.SeriesId and c.start_date <= a.dt and c.end_date >= a.dt
    where b.corever = 1 and date(date_sub(a.create_time, interval 13 hour)) >= '${bf_6_dt}' and date(date_sub(a.create_time, interval 13 hour)) <= '${bf_1_dt}'
    group by a.series_id
) c on a.SeriesId = c.series_id
left join (
    -- 曝光人数
    select
        shortplay_id,
        count(distinct login_id) as exposure_num
    from ads.ads_sensors_cd_video_itemexposure_view a
    left join series c
    on a.shortplay_id = c.SeriesId and c.start_date <= a.dt and c.end_date >= a.dt
    where a.core = 1 and date(date_sub(event_tm, interval 13 hour)) >= '${bf_6_dt}' and date(date_sub(event_tm, interval 13 hour)) <= '${bf_1_dt}'
    group by a.shortplay_id
) d on a.SeriesId = d.shortplay_id
group by a.start_date, a.end_date, a.SeriesId, a.LangId;
