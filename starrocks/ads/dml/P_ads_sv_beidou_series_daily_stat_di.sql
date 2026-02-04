----------------------------------------------------------------
-- 程序功能： 北斗短剧每日信息统计表
-- 程序名： P_ads_sv_beidou_series_daily_stat_di
-- 目标表： ads.ads_sv_beidou_series_daily_stat_di
-- 负责人： roger
-- 开发日期：2026-01-26
-- 版本号： v1.0
----------------------------------------------------------------

-- DML
insert into ads.ads_sv_beidou_series_daily_stat_di
with 
-- 观看记录基础数据(按用户+短剧+集聚合，关联用户表获取core和language_code)
watch_base as (
    select t1.dt
         , t1.account_id                     as user_id
         , t1.series_id
         , t1.epis_id
         , t1.epis_num
         , coalesce(t2.corever2, 0)          as core
         , coalesce(t2.current_language2, 0) as language_code
         , sum(t1.watch_stamp)               as sum_watch_stamp -- 用户在该集的观看时长
         , max(t1.watch_stamp)               as max_watch_stamp -- 用户在该集的观看进度
    from dwd.dwd_video_short_video_epis_history t1
    left join dim.dim_short_video_user_accountinfo t2
      on t1.account_id = t2.user_id
    where t1.dt >= '${bf_4_dt}' and t1.dt <= '${dt}'
    group by 1, 2, 3, 4, 5, 6, 7
),

-- 短剧每集时长信息
epis_duration as (
    select series_id
         , epis_id
         , epis_num
         , duration
         , row_number() over(partition by series_id order by epis_num desc) as rn  -- 最后一集rn=1
    from dim.dim_short_video_epis_view
),

-- 用户维度的短剧观看汇总
user_series_stat as (
    select w.dt
         , w.user_id
         , w.series_id
         , w.core
         , w.language_code
         , sum(w.sum_watch_stamp)                                          as total_watch_duration      -- 用户观看该短剧的总时长
         , count(distinct w.epis_id)                                       as watch_epis_count          -- 用户观看的集数
         , max(case when w.epis_num = 1 then w.max_watch_stamp else 0 end) as first_epis_watch_duration -- 首集观看进度
         , max(case when w.epis_num = 1 then e.duration else 0 end)        as first_epis_duration       -- 首集总时长
         , max(case when e.rn = 1 then w.max_watch_stamp else 0 end)       as last_epis_watch_duration  -- 最后一集观看进度
         , max(case when e.rn = 1 then e.duration else 0 end)              as last_epis_duration        -- 最后一集总时长
    from watch_base w
    left join epis_duration e
      on w.series_id = e.series_id
     and w.epis_id = e.epis_id
    group by w.dt, w.user_id, w.series_id, w.core, w.language_code
),

-- 短剧维度统计(按core, language_code分组)
series_stat as (
    select dt
         , core
         , language_code
         , series_id
         -- 首集完播用户(进度>=95%)
         , bitmap_agg(case when first_epis_duration > 0
                           and first_epis_watch_duration >= first_epis_duration * 0.95
                                                             then user_id end)  as first_epis_complete_user
         -- 首集总观众
         , bitmap_agg(case when first_epis_watch_duration > 0 then user_id end) as first_epis_total_user
         -- <=10s流失用户
         , bitmap_agg(case when total_watch_duration <= 10 then user_id end) as loss_10s_user
         -- >=10分钟用户
         , bitmap_agg(case when total_watch_duration >= 600 then user_id end) as complete_10min_user
         -- >=30分钟用户
         , bitmap_agg(case when total_watch_duration >= 1800 then user_id end) as complete_30min_user
         -- >=60分钟用户
         , bitmap_agg(case when total_watch_duration >= 3600 then user_id end) as complete_60min_user
         -- 整剧完播用户(最后一集进度>=95%)
         , bitmap_agg(case when last_epis_duration > 0
                           and last_epis_watch_duration >= last_epis_duration * 0.95
                      then user_id end) as complete_series_user
         -- 总播放集数
         , sum(watch_epis_count) as total_play_epis_count
         -- 总播放时长
         , sum(total_watch_duration) as total_play_duration
         -- 播放总用户
         , bitmap_agg(user_id) as play_user
    from user_series_stat
    where series_id is not null
    group by dt, core, language_code, series_id
),

-- 播放量统计(日志上报2次事件start/end，播放量=ceil(记录数/2))
play_count_stat as (
    select t1.dt
         , t2.corever2          as core
         , t2.current_language2 as language_code
         , t1.series_id
         , ceil(count(1) / 2)   as play_count
    from dwd.dwd_video_short_video_epis_history t1
    left join dim.dim_short_video_user_accountinfo t2
      on t1.account_id = t2.user_id
    where t1.dt >= '${bf_4_dt}' and t1.dt <= '${dt}'
    group by t1.dt, t2.corever2, t2.current_language2, t1.series_id
),

-- 点击曝光统计
click_exposure_stat as (
    select dt
         , core
         , current_language2 as language_code
         , shortplay_id      as series_id
         , sum(click_num)    as click_num
         , sum(exposure_num) as exposure_num
    from (
        select dt
             , core
             , current_language2
             , shortplay_id
             , count(1) as click_num
             , 0        as exposure_num
        from ads.ads_sensors_cd_video_itemclick_view
        where dt >= '${bf_4_dt}' and dt <= '${dt}'
        group by dt, core, current_language2, shortplay_id
        
        union all
        
        select dt
             , core
             , current_language2
             , shortplay_id
             , 0        as click_num
             , count(1) as exposure_num
        from ads.ads_sensors_cd_video_itemexposure_view
        where dt >= '${bf_4_dt}' and dt <= '${dt}'
        group by dt, core, current_language2, shortplay_id
    ) t
    group by dt, core, current_language2, shortplay_id
)

-- 最终输出
select s.dt                                 as dt
     , s.core
     , s.language_code
     , s.series_id
     , dic.cd_val_desc                      as language_name
     , v.series_code
     , v.series_name
     , v.all_epis
     , v.cover_url
     , v.publish_edat                       as publish_time
     , se.series_duration                   as series_duration
     -- 点击曝光
     , coalesce(ce.click_num, 0)            as click_num
     , coalesce(ce.exposure_num, 0)         as exposure_num
     -- bitmap指标
     , s.first_epis_complete_user
     , s.first_epis_total_user
     , s.loss_10s_user
     , s.complete_10min_user
     , s.complete_30min_user
     , s.complete_60min_user
     , s.complete_series_user
     -- 播放指标
     , coalesce(s.total_play_epis_count, 0) as total_play_epis_count
     , coalesce(s.total_play_duration, 0)   as total_play_duration
     , s.play_user
     , coalesce(p.play_count, 0)            as play_count
     , now()                                as etl_time
from series_stat                                       s
left join dim.dim_short_video_series_view v
  on s.series_id = v.series_id
left join dim.dim_pub_code_mapping_dict dic
  on dic.app_plat = 'pub'
 and dic.cd_col = 'lang_cd'
 and dic.cd_val = s.language_code
left join play_count_stat                     p
  on s.dt = p.dt
 and s.core = p.core
 and s.language_code = p.language_code
 and s.series_id = p.series_id
left join click_exposure_stat                 ce
  on s.dt = ce.dt
 and s.core = ce.core
 and s.language_code = ce.language_code
 and s.series_id = ce.series_id
left join (select series_id
                , sum(Duration) as series_duration
           from dim.dim_short_video_epis_view
           group by series_id
          ) se on s.series_id = se.series_id
;

