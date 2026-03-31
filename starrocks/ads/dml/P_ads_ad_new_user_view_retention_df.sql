----------------------------------------------------------------
-- 程序功能： 海外短剧-新用户留存表
-- 程序名： P_ads_ad_new_user_view_retention_df
-- 目标表： ads.ads_ad_new_user_view_retention_df
-- 负责人： xjc
-- 开发日期： 2026-01-26
----------------------------------------------------------------

insert into ads.ads_ad_new_user_view_retention_df
with video_watch_duration as (
    select dt
          ,product_id
          ,user_id
          ,shortplay_id                 as book_id
          ,watch_episode_sort
          ,epis_id                      as chapter_id
          ,duration * watch_progress    as watch_duration
      from (select a1.dt
                  ,a1.product_id
                  ,a1.login_id               as user_id
                  ,a1.shortplay_id
                  ,a1.watch_episode_sort
                  ,a2.duration
                  ,a2.epis_id
                  ,max(a1.watch_progress)    as watch_progress
              from ads.ads_sensors_cd_video_endwatching_view    as a1
              left join dim.dim_short_video_epis_view           as a2
                on a1.shortplay_id=a2.series_id
               and a1.watch_episode_sort=a2.epis_num
             where a1.dt between '${bf_8_dt}'
               and '${dt}'
               and a1.watch_progress is not null
               and a1.watch_progress > 0
             group by 1, 2, 3, 4, 5, 6, 7
           )    as a1
)
, video_short_video_epis as (
    select dt
          ,id
          ,account_id
          ,series_id
          ,epis_id
          ,watch_stamp
          ,create_time
          ,epis_num
          ,region_id
          ,watch_over
      from dwd.dwd_video_short_video_epis_history_est
     where dt>='${bf_8_dt}'
       and dt<'${bf_1_dt}'
     union
    select date(hours_add(CreateTime,-13))    as dt
          ,Id                                 as id
          ,AccountId                          as account_id
          ,SeriesId                           as series_id
          ,EpisId                             as epis_id
          ,case when a1.WatchOver = 1 then ifnull(a2.duration, a1.WatchStamp)
           else a1.WatchStamp
            end                               as WatchStamp
          ,hours_add(CreateTime,-13)          as create_time
          ,EpisNum                            as epis_num
          ,regionId                           as region_id
          ,WatchOver                          as watch_over
      from ods.ods_tidb_short_video_log_ext_epis_history_part2    as a1
      left join dim.dim_short_video_epis_view                     as a2
        on a1.EpisId = a2.epis_id
     where a1.dt >= '${bf_3_dt}'
       and a1.dt <= '${dt}'
       and date(hours_add(a1.CreateTime,-13)) >= '${bf_1_dt}'
       and date(hours_add(a1.CreateTime,-13)) <= '${dt}'
)
, view_unit_cnt as (
    select dt
          ,product_id
          ,user_id
          ,book_id
          ,chapter_id
          ,max(read_times)    as watch_duration
      from dwd.dwd_read_user_chapter_view
     where dt between '${bf_8_dt}'
       and '${dt}'
       and read_times > 0
     group by 1, 2, 3, 4, 5
     union all
    select a1.dt
          ,6833                                               as product_id
          ,a1.account_id                                      as user_id
          ,a1.series_id                                       as book_id
          ,a1.epis_id                                         as chapter_id
          ,max(coalesce(a2.watch_duration,a1.watch_stamp))    as watch_duration
      from video_short_video_epis       as a1
      left join video_watch_duration    as a2
        on a1.dt = a2.dt
       and a1.account_id = a2.user_id
       and a1.series_id = a2.book_id
       and a1.epis_id = a2.chapter_id
     where a1.dt between '${bf_8_dt}'
       and '${dt}'
     group by 1, 2, 3, 4, 5
)
, active_user as (
    select a1.dt
          ,a1.product_id
          ,a1.user_id
      from (select dt
                  ,product_id
                  ,user_id
              from dws.dws_user_wide_active_ed
             where dt between '${bf_7_dt}'
               and '${dt}'
             union all
            select dt
                  ,product_id
                  ,user_id
              from dws.dws_user_short_video_wide_active_ed
             where dt between '${bf_7_dt}'
               and '${dt}'
           )                                as a1
      join dim.dim_pub_code_mapping_dict    as a2
        on a1.product_id = a2.cd_val
       and a2.app_plat = 'pub'
       and a2.cd_col = 'product_id'
       and a2.p_cd_desc in('海阅','海剧')
     group by 1, 2, 3
)
, installreferrer_new_user as (
    select a1.dt
          ,a1.UserId             as user_id
          ,ifnull(a1.AdId,'')    as ad_id
          ,a1.ProductId          as product_id
      from ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer    as a1
     where a1.dt between '${bf_8_dt}'
       and '${dt}'
       and a1.IsDelete = 0
     group by 1, 2, 3, 4
)
, view_detail as (
    select a1.dt
          ,a1.user_id
          ,a1.ad_id
          ,a1.product_id
          ,a3.book_id                as content_id
          ,a3.chapter_id
          ,max(a3.watch_duration)    as watch_duration
      from installreferrer_new_user    as a1
      left join view_unit_cnt          as a3
        on a1.user_id = a3.user_id
       and a1.product_id = a3.product_id
       and a1.dt = a3.dt
     group by 1, 2, 3, 4, 5, 6
)
, retention_agg as (
    select a1.dt
          ,a1.product_id
          ,a1.ad_id
          ,count(distinct case when datediff(a2.dt, a1.dt) = 1 then a1.user_id end)    as d1_num
          ,count(distinct case when datediff(a2.dt, a1.dt) = 2 then a1.user_id end)    as d2_num
          ,count(distinct case when datediff(a2.dt, a1.dt) = 3 then a1.user_id end)    as d3_num
          ,count(distinct case when datediff(a2.dt, a1.dt) = 4 then a1.user_id end)    as d4_num
          ,count(distinct case when datediff(a2.dt, a1.dt) = 5 then a1.user_id end)    as d5_num
          ,count(distinct case when datediff(a2.dt, a1.dt) = 6 then a1.user_id end)    as d6_num
          ,count(distinct case when datediff(a2.dt, a1.dt) = 7 then a1.user_id end)    as d7_num
      from installreferrer_new_user    as a1
      join active_user                 as a2
        on a1.dt < a2.dt
       and a1.user_id = a2.user_id
       and a1.product_id = a2.product_id
     group by 1, 2, 3
)
, view_agg as (
    select a1.dt
          ,a1.product_id
          ,a1.ad_id
          ,sum(watch_duration)           as view_time
          ,count(chapter_id)             as view_unit_cnt
          ,count(distinct content_id)    as view_content_cnt
      from view_detail    as a1
     group by 1, 2, 3
)
select a1.dt                         as dt                  -- 日期
      ,md5(concat_ws('|'
                     ,ifnull(a1.dt,'')
                     ,ifnull(a1.product_id,'')
                     ,ifnull(a1.ad_id,'')
                    )
          )                          as md5_key             -- md5_key联合主键
      ,a1.product_id                 as product_id          -- 产品id
      ,if(a1.product_id=6833,8,5)    as project_id          -- 海剧海阅标识
      ,a1.ad_id                      as ad_id               -- 广告id
      ,count(distinct user_id)       as new_user_count      -- 新用户数
      ,max(a2.view_time)             as view_time           -- 观看剧集/书籍时长-单位秒
      ,max(a2.view_unit_cnt)         as view_unit_cnt       -- 观看剧集/书籍集数
      ,max(a2.view_content_cnt)      as view_content_cnt    -- 观看剧集/书籍部数
      ,max(a3.d1_num)                as d1_num              -- d1留存人数
      ,max(a3.d2_num)                as d2_num              -- d2留存人数
      ,max(a3.d3_num)                as d3_num              -- d3留存人数
      ,max(a3.d4_num)                as d4_num              -- d4留存人数
      ,max(a3.d5_num)                as d5_num              -- d5留存人数
      ,max(a3.d6_num)                as d6_num              -- d6留存人数
      ,max(a3.d7_num)                as d7_num              -- d7留存人数
      ,now()                         as etl_tm              -- 清洗时间
  from installreferrer_new_user    as a1
  left join view_agg               as a2
    on a1.dt = a2.dt
   and a1.product_id = a2.product_id
   and a1.ad_id = a2.ad_id
  left join retention_agg          as a3
    on a1.dt = a3.dt
   and a1.product_id = a3.product_id
   and a1.ad_id = a3.ad_id
 group by 1, 2, 3, 4, 5
;