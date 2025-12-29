----------------------------------------------------------------
-- 程序功能： 短剧观看时长小于等于5秒明细
-- 程序名： P_ads_video_user_watch_lte5s_di
-- 目标表： ads.ads_video_user_watch_lte5s_di
-- 负责人： xjc
-- 开发日期：2025-12-24
-- 版本号：v0.0.1
----------------------------------------------------------------

insert into ads.ads_video_user_watch_lte5s_di
select a1.dt                  as dt             -- 日期
      ,a1.account_id          as user_id        -- 用户id
      ,a1.series_id           as series_id      -- 剧集id
      ,sum(a1.watch_stamp)    as watch_stamp    -- 看剧时间，秒
      ,now()                  as etl_tm         -- etl时间
from dwd.dwd_video_short_video_epis_history    as a1
where dt >='${bf_1_dt}'
  and dt <='${dt}'
group by 1,2,3
having sum(watch_stamp) <= 5
;