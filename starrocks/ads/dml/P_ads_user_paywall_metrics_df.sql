----------------------------------------------------------------
-- 程序功能：付费墙用户行为指标
-- 程序名： P_ads_user_paywall_metrics_df
-- 目标表： ads.ads_user_paywall_metrics_df
-- 负责人： xjc
-- 开发日期： 2026-04-29
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_user_paywall_metrics_df
select a1.dt
      ,a1.user_id                 as user_id                     -- 统计日期
      ,null                       as recharge_unlock_epis_cnt    -- 用户id
      ,null                       as watch_min                   -- 前3d充值解锁集数
      ,null                       as ad_unlock_epis_cnt          -- 前3d观看分钟数
      ,null                       as watch_epis_cnt              -- 前3d看广告解锁集数
      ,null                       as watch_series_cnt            -- 前3d看集数
      ,null                       as max_watch_epis_cnt          -- 前3d看剧数
      ,max(a1.max_active_time)    as max_active_time             -- 前3d单剧最大观看集数
      ,now()                      as etl_time                    -- 最大活跃时间
  from dws.dws_user_short_video_wide_active_ed    as a1
 where a1.dt >= '${bf_1_dt}'
   and a1.dt <= '${dt}'
   and a1.product_id = 6833
   and a1.max_active_time is not null
 group by 1, 2, 3
;










