----------------------------------------------------------------
-- 程序功能： 海剧用户观看剧集指标表
-- 程序名： P_ads_sv_user_watch_series_di
-- 目标表： ads.ads_sv_user_watch_series_di
-- 负责人： qhr
-- 开发日期： 2026-01-15
----------------------------------------------------------------

insert into ads.ads_sv_user_watch_series_di
select a.user_id
     , bitmap_to_string(a.watch_series_td)                      as watch_series_td
     , now()                                                    as etl_time
     , now()                                                    as row_update_time
  from dws.dws_user_sv_accumulate_idx_his_15df                  as a
 where a.dt = '${bf_1_dt}'
   and exists (select 1
                 from dwd.dwd_video_short_video_epis_history    as b
                where b.dt = '${bf_1_dt}'
                  and b.account_id = a.user_id
              )
;