----------------------------------------------------------------
-- 程序功能： 北斗短剧播放量趋势表(小时粒度)
-- 程序名： P_ads_sv_beidou_series_play_trend_hi
-- 目标表： ads.ads_sv_beidou_series_play_trend_hi
-- 负责人： roger
-- 开发日期：2026-01-26
-- 版本号： v1.0
----------------------------------------------------------------

-- DML
insert into ads.ads_sv_beidou_series_play_trend_hi_v2
with
dl_user_set as (
    select lv.series_id
         , b.user_id
    from ads.ads_short_video_video_dl_log_view lv
    left join dim.dim_short_video_user_accountinfo b
      on lv.unique_cdreader_id = b.unique_cdreader_id
    where lv.has_open = 1
      and lv.create_time >= date_add(cast('${dt}' as datetime), -200)
      and lv.create_time <= cast('${dt}' as datetime)
      and lv.series_id is not null
      and b.user_id is not null
    group by 1, 2
),

-- 去重底表(endwatching 同用户+剧+集可能上报几百次，core 从 app_id 提取)
epis_watch_view as (
    select ew.dt
         , ew.login_id                                          as user_id
         , coalesce(cast(substring(ew.app_id, 4, 3) as int), 0) as core
         , ew.shortplay_id                                      as series_id
         , ew.episode_id                                        as epis_id
         , ew.watch_episode_sort                                as epis_num
         , min(ew.event_tm)                                     as create_time
         , max(if(cast(ew.watch_progress as double) > 1, 1,
                  cast(ew.watch_progress as double)))           as watch_progress
    from dwd.dwd_sensors_cd_video_endwatching_view ew
    left semi join dim.dim_short_video_epis_view e
      on ew.shortplay_id = e.series_id
     and ew.episode_id = e.epis_id
    where ew.dt >= '${bf_4_dt}'
      and ew.dt <= '${dt}'
      and ew.shortplay_id is not null
      and ew.app_id is not null
    group by 1, 2, 3, 4, 5, 6
),

-- 按小时统计播放量(底表每行=一次播放，count(1)=播放量)
hourly_play as (
    select ew.dt
         , date_trunc('hour', ew.create_time)  as hour_time
         , ew.core
         , case when du.user_id is not null then 1 else 0 end as acquisition_source_cd
         , coalesce(s.language, 0)             as language_code
         , ew.series_id
         , count(1)                            as play_count
    from epis_watch_view ew
    left join dl_user_set du
      on ew.series_id = du.series_id
     and ew.user_id = du.user_id
    left join dim.dim_short_video_series_view s
      on ew.series_id = s.series_id
    group by 1, 2, 3, 4, 5, 6
),
-- 枚举基础信息
series_attr as (
    select sv.SeriesId      as series_id
         , sv.SeriesLevel   as series_level
         , sv.WorkType      as work_type
         , ssv.LocalType    as local_type
         , ssv.LocalSubType as local_sub_type
         , ssv.AudioType    as audio_type
         , ssv.DubbedType   as dubbed_type
    from ads.ads_series_view sv
    left join ads.ads_source_series_view ssv
      on sv.SourceSeriesId = ssv.SeriesId
)

select h.dt
     , h.hour_time
     , h.core
     , h.acquisition_source_cd
     , h.language_code
     , h.series_id
     , dic.cd_val_desc                  as language_name
     , v.series_code
     , v.series_name
     , s.series_level                   as series_level
     , s.work_type                      as work_type
     , s.local_type                     as local_type
     , s.local_sub_type                 as local_sub_type
     , s.audio_type                     as audio_type
     , s.dubbed_type                    as dubbed_type
     , date(h.hour_time)                as day_time
     , date_trunc('month', h.hour_time) as month_time
     , h.play_count
     , now()                            as etl_time
from hourly_play h
left join dim.dim_short_video_series_view v
  on h.series_id = v.series_id
left join series_attr s
  on h.series_id = s.series_id
left join dim.dim_pub_code_mapping_dict dic
  on dic.app_plat = 'pub'
 and dic.cd_col = 'lang_cd'
 and dic.cd_val = h.language_code
;
