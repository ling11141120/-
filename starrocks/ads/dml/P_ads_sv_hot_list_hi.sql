----------------------------------------------------------------
-- 程序功能：海剧排行榜热度指标计算口径
-- 程序名： P_ads_sv_hot_list_hi
-- 目标表： ads.ads_sv_hot_list_hi
-- 负责人： xjc
-- 开发日期：2025-11-21
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_sv_hot_list_hi
select date(date_sub('${dt}', interval 1 hour))    as dt               -- 日期
      ,date_format(
                    date_sub('${dt}', interval 1 hour)
                   ,'%Y%m%d%H'
                  )                                as stat_dt_h        -- 统计时间
      ,a1.series_id                                as series_id        -- 短剧ID
      ,a2.language                                 as language         -- 语言ID
      ,a3.corever                                  as core             -- 核心版本
      ,sum(amt_weight)                             as amt_weight       -- 观看付费集权重值
      ,sum(consume_coin)                           as consume_coin     -- 消费观看币数
      ,sum(consume_bonus)                          as consume_bonus    -- 消费观看券数
      ,sum(watch_cnt)                              as watch_cnt        -- 播放次数
      ,sum(like_cnt)                               as like_cnt         -- 点赞次数
      ,sum(follow_cnt)                             as follow_cnt       -- 添加追剧
      ,now()                                       as etl_time         -- 清洗时间
  from (select shortplay_id                                                    as series_id
              ,login_id                                                        as user_id
              ,(count(distinct if(unlock_type = 3, episode_id, null)) * 80)
                +
               (count(distinct if(unlock_type = 8, episode_id, null)) * 50)    as amt_weight
              ,0                                                               as consume_coin
              ,0                                                               as consume_bonus
              ,0                                                               as watch_cnt
              ,0                                                               as like_cnt
              ,0                                                               as follow_cnt
          from dwd.dwd_sensors_cd_video_unlockEpisode_view
         where unlock_type in(3, 8)
           and event_tm >= date_sub('${dt}', interval 1 hour)
           and event_tm <= '${dt}'
         group by 1, 2
         union all
        select series_id
              ,account_id
              ,0
              ,sum(distinct if(consume_type = 0, consume_value, 0))
              ,sum(distinct if(consume_type = 1, consume_value, 0))
              ,0
              ,0
              ,0
          from dwd.dwd_sv_consume_user_consume_bill_pdi
         where create_time >= date_sub('${dt}', interval 1 hour)
           and create_time <= '${dt}'
         group by 1, 2
         union all
        select series_id
              ,account_id
              ,0
              ,0
              ,0
              ,count(1)
              ,0
              ,0
          from (select c1.AccountId     as account_id
                      ,c1.SeriesId      as series_id
                      ,if(c1.WatchOver = 1
                         ,ifnull(c2.duration, c1.WatchStamp)
                         ,c1.WatchStamp
                         )              as watch_stamp
                      ,c1.CreateTime    as create_time
                  from ods.ods_tidb_short_video_log_ext_epis_history_part2    as c1
                  left join dim.dim_short_video_epis_view                     as c2
                    on c1.EpisId = c2.epis_id
                 where c1.dt >= '${bf_4_dt}'
                   and c1.dt <= substr('${dt}', 1, 10)
               )    as b1
         where watch_stamp != 0
           and create_time >= date_sub('${dt}', interval 1 hour)
           and create_time <= '${dt}'
         group by 1, 2
         union all
        select series_id
              ,user_id
              ,0
              ,0
              ,0
              ,0
              ,count(1)
              ,0
          from dwd.dwd_video_short_video_account_like_view
         where is_delete = 0
           and create_time >= date_sub('${dt}', interval 1 hour)
           and create_time <= '${dt}'
         group by 1, 2
         union all
        select SeriesId
              ,AccountId
              ,0
              ,0
              ,0
              ,0
              ,0
              ,count(1)
          from ods.ods_tidb_short_video_follow_series
         where CreateTime >= date_sub('${dt}', interval 1 hour)
           and CreateTime <= '${dt}'
         group by 1, 2
       )                                            as a1
  left join dim.dim_short_video_series_view         as a2
    on a1.series_id = a2.series_id
  left join dim.dim_short_video_user_accountinfo    as a3
    on a1.user_id = a3.user_id
 where a1.series_id is not null
   and a2.language is not null
   and a3.corever is not null
 group by 1, 2, 3, 4, 5
;