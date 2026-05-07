----------------------------------------------------------------
-- 程序功能：付费墙用户行为指标
-- 程序名： P_ads_user_paywall_metrics_df
-- 目标表： ads.ads_user_paywall_metrics_df
-- 负责人： xjc
-- 开发日期： 2026-04-29
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_user_paywall_metrics_df
with active_user as (
    select a1.dt
          ,a1.user_id                 as user_id
          ,max(a1.max_active_time)    as max_active_time
      from dws.dws_user_short_video_wide_active_ed    as a1
     where a1.dt >= '${bf_1_dt}'
       and a1.dt <= '${dt}'
       and a1.product_id = 6833
       and a1.max_active_time is not null
     group by 1, 2
)
-- 充值解锁集数
, unlock_agg as (
    select a1.dt
          ,a1.user_id
          ,count(distinct case when cast(a2.unlock_type as string) not regexp '^(4|5|7|8)$'     -- 业务要求，剔除4、5、7、8
                               then concat(ifnull(cast(a2.shortplay_id as string), '-99'), '_', ifnull(cast(a2.episode_id as string), '-99'))
                           end)    as recharge_unlock_epis_cnt
          ,count(distinct case when a2.unlock_type = '8'
                               then concat(ifnull(cast(a2.shortplay_id as string), '-99'), '_', ifnull(cast(a2.episode_id as string), '-99'))
                           end)    as ad_unlock_epis_cnt
      from active_user                                         as a1
      left join ads.ads_sensors_cd_video_unlockEpisode_view    as a2
        on a2.login_id = a1.user_id
       and a2.dt >= date_sub(a1.dt, interval 2 day)
       and a2.dt <= a1.dt
       and a2.dt >= '${bf_3_dt}'
       and a2.dt <= '${dt}'
       and a2.product_id = 6833
       and a2.unlock_type in ('1', '2', '3', '6', '8', '9', '10', '11')
     group by 1, 2
)
-- 观看记录基础表
, watch_epis_base as (
    select a1.dt
          ,a1.account_id    as user_id
          ,a1.series_id
          ,a1.epis_id
          ,sum(a1.watch_stamp)              as watch_stamp
      from dwd.dwd_video_short_video_epis_history    as a1
     where a1.dt >= '${bf_3_dt}'
       and a1.dt <= '${dt}'
       and a1.account_id >= 0
       and a1.series_id is not null
       and a1.epis_id is not null
     group by 1, 2, 3, 4
)
, watch_agg as (
    select a1.dt
          ,a1.user_id
          ,round(sum(a2.watch_stamp) / 60.0, 2)  as watch_min
          ,count(distinct concat(cast(a2.series_id as string), '_', cast(a2.epis_id as string)))    as watch_epis_cnt
          ,count(distinct a2.series_id)          as watch_series_cnt
      from active_user          as a1
      left join watch_epis_base as a2
        on a1.user_id = a2.user_id
       and a2.dt >= date_sub(a1.dt, interval 2 day)
       and a2.dt <= a1.dt
     group by 1, 2
)
, watch_series_agg as (
    select a1.dt
          ,a1.user_id
          ,a2.series_id
          ,count(distinct concat(cast(a2.series_id as string), '_', cast(a2.epis_id as string)))    as watch_epis_cnt
      from active_user          as a1
      join watch_epis_base      as a2
        on a1.user_id = a2.user_id
       and a2.dt >= date_sub(a1.dt, interval 2 day)
       and a2.dt <= a1.dt
     group by 1, 2, 3
)
, max_watch_series_agg as (
    select dt
          ,user_id
          ,max(watch_epis_cnt)    as max_watch_epis_cnt
      from watch_series_agg
     group by 1, 2
)
select a1.dt                                         as dt
      ,a1.user_id                                    as user_id
      ,ifnull(a2.recharge_unlock_epis_cnt, 0)        as recharge_unlock_epis_cnt
      ,ifnull(a3.watch_min, 0)                       as watch_min
      ,ifnull(a2.ad_unlock_epis_cnt, 0)              as ad_unlock_epis_cnt
      ,ifnull(a3.watch_epis_cnt, 0)                  as watch_epis_cnt
      ,ifnull(a3.watch_series_cnt, 0)                as watch_series_cnt
      ,ifnull(a4.max_watch_epis_cnt, 0)              as max_watch_epis_cnt
      ,a1.max_active_time                            as max_active_time
      ,now()                                         as etl_time
  from active_user               as a1
  left join unlock_agg           as a2
    on a1.dt = a2.dt
   and a1.user_id = a2.user_id
  left join watch_agg            as a3
    on a1.dt = a3.dt
   and a1.user_id = a3.user_id
  left join max_watch_series_agg as a4
    on a1.dt = a4.dt
   and a1.user_id = a4.user_id
;