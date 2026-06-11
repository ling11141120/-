----------------------------------------------------------------
-- 程序功能： 北斗短剧每集观看数据统计表
-- 程序名： P_ads_sv_beidou_series_epis_stat_di
-- 目标表： ads.ads_sv_beidou_series_epis_stat_di
-- 负责人： roger
-- 开发日期：2026-01-26
-- 版本号： v1.0
----------------------------------------------------------------

SET cbo_cte_reuse = true;  -- 开启 CTE 复用

-- DML
insert into ads.ads_sv_beidou_series_epis_stat_di
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

-- 用户每集观看记录(底表已去重+含core，join dim取duration和language)
user_epis_watch as (
    select ew.dt
         , ew.user_id
         , ew.series_id
         , ew.epis_id
         , ew.epis_num
         , ew.core
         , case when du.user_id is not null then 1 else 0 end as acquisition_source_cd
         , coalesce(s.language, 0)                        as language_code
         , ew.watch_progress * coalesce(ev.duration, 0)   as max_watch_stamp
         , ew.create_time                                 as min_create_time
         , ew.create_time                                 as max_create_time
    from epis_watch_view ew
    left join dl_user_set du
      on ew.series_id = du.series_id
     and ew.user_id = du.user_id
    left join dim.dim_short_video_epis_view ev
      on ew.series_id = ev.series_id and ew.epis_id = ev.epis_id
    left join dim.dim_short_video_series_view s
      on ew.series_id = s.series_id
),

-- 续看用：按(dt, user, series, core, lang, epis_num)聚合min/max create_time(同剧多epis_id合并)
epis_time_agg as (
    select dt
         , user_id
         , series_id
         , core
         , acquisition_source_cd
         , language_code
         , epis_num
         , min(min_create_time) as min_create_time
         , max(max_create_time) as max_create_time
    from user_epis_watch
    group by 1, 2, 3, 4, 5, 6, 7
),

-- 本集观看日后任意dt内、24小时内观看下一集的记录(不绑dt，支持跨天通宵续看)
nxt_watch_tmp as (
    select cur.dt
         , cur.user_id
         , cur.series_id
         , cur.core
         , cur.acquisition_source_cd
         , cur.language_code
         , cur.epis_num
         , min(nxt.min_create_time) as next_min_create_time
    from epis_time_agg cur
    inner join epis_time_agg nxt
      on cur.user_id = nxt.user_id
     and cur.series_id = nxt.series_id
     and cur.core = nxt.core
     and cur.acquisition_source_cd = nxt.acquisition_source_cd
     and cur.language_code = nxt.language_code
     and nxt.epis_num = cur.epis_num + 1
    -- 优化续集关联条件
     and nxt.min_create_time >= cur.min_create_time
     and nxt.min_create_time <= hours_add(cur.min_create_time, 24)
    group by 1, 2, 3, 4, 5, 6, 7
),

-- 短剧最后一集信息，最后一集不计入流失观看用户
series_epis_boundary as (
    select series_id
         , max(epis_num) as last_epis_num
    from dim.dim_short_video_epis_view
    where is_delete = 0
    group by series_id
),

-- 用户是否观看了下一集(沿用24小时续看窗口，支持跨天)
user_next_epis as (
    select a.dt
         , a.user_id
         , a.series_id
         , a.epis_id
         , a.epis_num
         , a.core
         , a.acquisition_source_cd
         , a.language_code
         , a.max_watch_stamp
         , e.duration                                        as epis_duration
         , case
               when a.max_watch_stamp > e.duration then e.duration
               when e.duration is null then 0
               else a.max_watch_stamp end                    as capped_watch_stamp
         , case when n.next_min_create_time is not null then 1 else 0 end as has_next_epis
         , case when a.epis_num = b.last_epis_num then 1 else 0 end       as is_last_epis
    from user_epis_watch a
    left join dim.dim_short_video_epis_view e
      on a.series_id = e.series_id and a.epis_id = e.epis_id
    left join series_epis_boundary b
      on a.series_id = b.series_id
    left join epis_time_agg cur
      on a.dt = cur.dt and a.user_id = cur.user_id and a.series_id = cur.series_id
     and a.core = cur.core and a.acquisition_source_cd = cur.acquisition_source_cd and a.language_code = cur.language_code and a.epis_num = cur.epis_num
    left join nxt_watch_tmp n
      on a.dt = n.dt and a.user_id = n.user_id and a.series_id = n.series_id
     and a.core = n.core and a.acquisition_source_cd = n.acquisition_source_cd and a.language_code = n.language_code and a.epis_num = n.epis_num
    where a.series_id is not null
      and a.epis_id is not null
),

-- 每集统计(按core, language_code分组)
epis_stat as (
    select dt
         , core
         , acquisition_source_cd
         , language_code
         , series_id
         , epis_id
         , max(epis_num)                                                                                        as epis_num
         , max(epis_duration)                                                                                   as epis_duration
         , bitmap_agg(case when epis_duration > 0 and has_next_epis = 1 then user_id end)                       as next_epis_user
         , bitmap_agg(case when epis_duration > 0 then user_id end)                                             as epis_complete_user
         , sum(capped_watch_stamp)                                                                              as epis_total_watch_duration -- 观看进度最大时间的总时长(封顶)
         , bitmap_agg(case when max_watch_stamp >= 0 and max_watch_stamp < 5 then user_id end)                  as exit_0_5s_user
         , bitmap_agg(case when max_watch_stamp >= 5 and max_watch_stamp < 10 then user_id end)                 as exit_5_10s_user
         , bitmap_agg(case when max_watch_stamp >= 10 and max_watch_stamp < 20 then user_id end)                as exit_10_20s_user
         , bitmap_agg(case when max_watch_stamp >= 20 and max_watch_stamp < 30 then user_id end)                as exit_20_30s_user
         , bitmap_agg(case when max_watch_stamp >= 30 and max_watch_stamp < 40 then user_id end)                as exit_30_40s_user
         , bitmap_agg(case when max_watch_stamp >= 40 and max_watch_stamp < 50 then user_id end)                as exit_40_50s_user
         , bitmap_agg(case when max_watch_stamp >= 50 and max_watch_stamp < 60 then user_id end)                as exit_50_60s_user
         , bitmap_agg(case when max_watch_stamp >= 60 then user_id end)                                         as exit_60s_plus_user
         , bitmap_agg(user_id)                                                                                  as epis_watch_user
         , count(1)                                                                                             as play_count
         , bitmap_agg(case when max_watch_stamp > 5 then user_id end)                                           as effective_watch_user
         , bitmap_agg(case when max_watch_stamp > 5 and has_next_epis = 0 and is_last_epis = 0 then user_id end) as loss_watch_user
    from user_next_epis
    group by 1, 2, 3, 4, 5, 6
)

-- 最终输出
select s.dt
     , s.core
     , s.acquisition_source_cd
     , s.language_code
     , s.series_id
     , s.epis_id
     , s.epis_num
     , dic.cd_val_desc  as language_name
     , v.series_code
     , v.series_name
     , s.next_epis_user
     , s.epis_complete_user
     , s.epis_total_watch_duration
     , s.epis_duration
     , s.exit_0_5s_user
     , s.exit_5_10s_user
     , s.exit_10_20s_user
     , s.exit_20_30s_user
     , s.exit_30_40s_user
     , s.exit_40_50s_user
     , s.exit_50_60s_user
     , s.exit_60s_plus_user
     , s.epis_watch_user
     , s.play_count
     , s.effective_watch_user
     , s.loss_watch_user
     , now() as etl_time
from epis_stat s
left join dim.dim_short_video_series_view v
  on s.series_id = v.series_id
left join dim.dim_pub_code_mapping_dict dic
  on dic.app_plat = 'pub'
 and dic.cd_col = 'lang_cd'
 and dic.cd_val = s.language_code
;
