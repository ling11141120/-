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
-- 按小时统计播放量(日志上报2次事件start/end，播放量=ceil(记录数/2)，关联用户表获取core和language_code)
hourly_play as (
    select t1.dt
         , date_trunc('hour', t1.create_time) as hour_time
         , coalesce(t2.corever2, 0)           as core
         , coalesce(t2.current_language2, 0)  as language_code
         , t1.series_id
         , ceil(count(1) / 2)                 as play_count
    from dwd.dwd_video_short_video_epis_history t1
    left join dim.dim_short_video_user_accountinfo t2
      on t1.account_id = t2.user_id
    where t1.dt >= '${bf_4_dt}' and t1.dt <= '${dt}'
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
     , date(h.hour_time)                as day_time
     , date_trunc('month', h.hour_time) as month_time
     , h.play_count
     , now()                            as etl_time
from hourly_play h
left join dim.dim_short_video_series_view v
  on h.series_id = v.series_id
left join dim.dim_pub_code_mapping_dict dic
  on dic.app_plat = 'pub'
 and dic.cd_col = 'lang_cd'
 and dic.cd_val = h.language_code
;
