----------------------------------------------------------------
-- 程序功能： 北斗短剧播放量趋势表(小时粒度)
-- 程序名： P_ads_sv_beidou_series_play_trend_hi
-- 目标表： ads.ads_sv_beidou_series_play_trend_hi
-- 负责人： roger
-- 开发日期：2026-01-26
-- 版本号： v1.0
----------------------------------------------------------------

-- DML
insert into ads.ads_sv_beidou_series_play_trend_hi
with
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
         , coalesce(s.language, 0)             as language_code
         , ew.series_id
         , count(1)                            as play_count
    from epis_watch_view ew
    left join dim.dim_short_video_series_view s
      on ew.series_id = s.series_id
    group by 1, 2, 3, 4, 5
)

select h.dt
     , h.hour_time
     , h.core
     , h.language_code
     , h.series_id
     , dic.cd_val_desc                  as language_name
     , v.series_code
     , v.series_name
     , sv.SeriesLevel                   as series_level
     , sv.WorkType                      as work_type
     , ssv.LocalType                    as local_type
     , ssv.LocalSubType                 as local_sub_type
     , ssv.AudioType                    as audio_type
     , ssv.DubbedType                   as dubbed_type
     , date(h.hour_time)                as day_time
     , date_trunc('month', h.hour_time) as month_time
     , h.play_count
     , now()                            as etl_time
from hourly_play h
left join dim.dim_short_video_series_view v
  on h.series_id = v.series_id
left join ads.ads_series_view sv
  on h.series_id = sv.SeriesId
left join ads.ads_source_series_view ssv
  on h.series_id = ssv.SeriesId
left join dim.dim_pub_code_mapping_dict dic
  on dic.app_plat = 'pub'
 and dic.cd_col = 'lang_cd'
 and dic.cd_val = h.language_code
;
