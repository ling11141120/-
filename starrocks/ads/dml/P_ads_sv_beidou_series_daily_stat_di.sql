----------------------------------------------------------------
-- 程序功能： 北斗短剧每日信息统计表
-- 程序名： P_ads_sv_beidou_series_daily_stat_di
-- 目标表： ads.ads_sv_beidou_series_daily_stat_di
-- 负责人： roger
-- 开发日期：2026-01-26
-- 版本号： v1.0
----------------------------------------------------------------

-- 尝试开启Bitmap预聚合优化
SET new_planner_optimize_timeout = 3000;
-- 关闭 runtime 自适应并行（防止 bitmap 放大）
SET enable_runtime_adaptive_dop = false;

-- DML
insert into ads.ads_sv_beidou_series_daily_stat_di
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

-- 观看记录基础数据(底表已去重+含core，join dim取duration和language)
watch_base as (
    select ew.dt
         , ew.user_id
         , ew.series_id
         , ew.epis_id
         , ew.epis_num
         , ew.core
         , case when du.user_id is not null then 1 else 0 end as acquisition_source_cd
         , coalesce(s.language, 0)                        as language_code
         , ew.watch_progress * coalesce(ev.duration, 0)   as sum_watch_stamp
         , ew.watch_progress * coalesce(ev.duration, 0)   as max_watch_stamp
         , ew.watch_progress                               as watch_progress
         , ew.create_time                                  as create_time
         , ev.is_free
    from epis_watch_view ew
    left join dl_user_set du
      on ew.series_id = du.series_id
     and ew.user_id = du.user_id
    left join dim.dim_short_video_epis_view ev
      on ew.series_id = ev.series_id and ew.epis_id = ev.epis_id
    left join dim.dim_short_video_series_view s
      on ew.series_id = s.series_id
),

-- 短剧每集时长信息
epis_duration as (
    select series_id
         , epis_id
         , epis_num
         , duration
         , row_number() over(partition by series_id order by epis_num desc) as rn  -- 最后一集rn=1
    from dim.dim_short_video_epis_view
    where is_delete = 0
),

-- 短剧每集时长信息
epis_stat as (
    select dt
    , core
    , acquisition_source_cd
    , language_code
    , series_id
    -- 本剧解锁用户数
    , bitmap_agg(case when is_free = 0 then user_id end) as unlock_user
    -- 本剧解锁集数
    , bitmap_union(case when is_free = 0 then bitmap_hash(concat(cast(user_id as string), '_', epis_id)) end) as unlock_epis
    from watch_base w
    where series_id is not null
    group by dt, core, acquisition_source_cd, language_code, series_id
),

-- 用户维度的短剧观看汇总
user_series_stat as (
    select w.dt
         , w.user_id
         , w.series_id
         , w.core
         , w.acquisition_source_cd
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
    group by w.dt, w.user_id, w.series_id, w.core, w.acquisition_source_cd, w.language_code
),

-- 短剧维度统计(按core, language_code分组)
series_stat as (
    select dt
         , core
         , acquisition_source_cd
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
         -- <=5s跳出用户
         , bitmap_agg(case when total_watch_duration <= 5 then user_id end)  as exit_5s_user
         -- >=10秒用户
         , bitmap_agg(case when total_watch_duration >= 10 then user_id end) as complete_10s_user
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
    group by dt, core, acquisition_source_cd, language_code, series_id
),

-- 播放量统计(底表每行=一次播放，count(1)=播放量)
play_count_stat as (
    select ew.dt
         , ew.core
         , case when du.user_id is not null then 1 else 0 end as acquisition_source_cd
         , coalesce(s.language, 0)  as language_code
         , ew.series_id
         , count(1)                 as play_count
    from epis_watch_view ew
    left join dl_user_set du
      on ew.series_id = du.series_id
     and ew.user_id = du.user_id
    left join dim.dim_short_video_series_view s
      on ew.series_id = s.series_id
    group by 1, 2, 3, 4, 5
),

-- 点击曝光统计
click_exposure_stat as (
    select dt
         , core
         , acquisition_source_cd
         , current_language2 as language_code
         , shortplay_id      as series_id
         , sum(click_num)    as click_num
         , sum(exposure_num) as exposure_num
    from (
        select dt
             , core
             , case when du.user_id is not null then 1 else 0 end as acquisition_source_cd
             , current_language2
             , shortplay_id
             , count(1) as click_num
             , 0        as exposure_num
        from ads.ads_sensors_cd_video_itemclick_view c
        left join dl_user_set du
          on c.shortplay_id = du.series_id
         and c.login_id = du.user_id
        where dt >= '${bf_4_dt}' and dt <= '${dt}'
        group by dt, core, acquisition_source_cd, current_language2, shortplay_id

        union all

        select dt
             , core
             , case when du.user_id is not null then 1 else 0 end as acquisition_source_cd
             , current_language2
             , shortplay_id
             , 0        as click_num
             , count(1) as exposure_num
        from ads.ads_sensors_cd_video_itemexposure_view e
        left join dl_user_set du
          on e.shortplay_id = du.series_id
         and e.login_id = du.user_id
        where dt >= '${bf_4_dt}' and dt <= '${dt}'
        group by dt, core, acquisition_source_cd, current_language2, shortplay_id
    ) t
    group by dt, core, acquisition_source_cd, current_language2, shortplay_id
),

-- 枚举基础信息(名称使用 case when 映射)
series_attr as (
    select sv.SeriesId as series_id
         , sv.SeriesLevel as series_level
         , case sv.SeriesLevel
               when 1 then 'S'
               when 2 then 'A'
               when 3 then 'B'
               when 4 then 'C'
               else null
           end as series_level_name
         , sv.WorkType as work_type
         , case sv.WorkType
               when 1 then '男频'
               when 2 then '女频'
               when 3 then '双番'
               else null
           end as work_type_name
         , ssv.LocalType as local_type
         , case ssv.LocalType
               when 1 then '本土剧'
               when 2 then '译制剧'
               when 4 then '动态漫'
               else null
           end as local_type_name
         , ssv.LocalSubType as local_sub_type
         , case ssv.LocalSubType
               when 1 then '本土剧-AI短剧'
               else null
           end as local_sub_type_name
         , ssv.AudioType as audio_type
         , case ssv.AudioType
               when 1 then '原声剧'
               when 2 then '配音剧'
               else null
           end as audio_type_name
         , ssv.DubbedType as dubbed_type
         , case ssv.DubbedType
               when 1 then '人工配音'
               when 2 then 'AI配音'
               else null
           end as dubbed_type_name
    from ads.ads_series_view sv
    left join ads.ads_source_series_view ssv
      on sv.SourceSeriesId = ssv.SeriesId
),

-- 分类标签聚合
series_type_agg as (
    select srt.series_id                          as series_id
         , group_concat(st.name order by st.name) as series_type_labels
    from dim.dim_short_video_series_ref_type_view           srt
    left join dim.dim_short_video_series_type_view st
    on srt.series_type_id = st.id
    group by srt.series_id
),

series_pay_boundary as (
    select series_id
         , sum(duration)                                as series_duration
         , min(case when is_free = 0 then epis_num end) as first_pay_epis_num
    from dim.dim_short_video_epis_view
    where is_delete = 0
    group by series_id
),

loss_stat_raw as (
    select w.dt
         , w.core
         , w.acquisition_source_cd
         , w.language_code
         , w.series_id
         , bitmap_agg(case when w.epis_num = 3 then w.user_id end) as epis3_watch_user
         , bitmap_agg(case when w.epis_num = 4 then w.user_id end) as epis4_watch_user
         , bitmap_agg(case when pb.first_pay_epis_num is not null
                                and pb.first_pay_epis_num > 1
                                and w.epis_num = pb.first_pay_epis_num - 1
                           then w.user_id end)                     as paid_prev_watch_user
         , bitmap_agg(case when pb.first_pay_epis_num is not null
                                and pb.first_pay_epis_num > 1
                                and w.epis_num = pb.first_pay_epis_num
                           then w.user_id end)                     as paid_start_watch_user
    from watch_base w
    left join series_pay_boundary pb
      on w.series_id = pb.series_id
    group by 1, 2, 3, 4, 5
),

loss_stat as (
    select dt
         , core
         , acquisition_source_cd
         , language_code
         , series_id
         , epis3_watch_user
         , epis4_watch_user
         , bitmap_andnot(epis3_watch_user, epis4_watch_user) as epis3_loss_user
         , paid_prev_watch_user
         , paid_start_watch_user
         , bitmap_andnot(paid_prev_watch_user, paid_start_watch_user) as paid_loss_user
    from loss_stat_raw
),

-- 解锁明细(广告解锁 + 币券解锁 + VIP解锁)
unlock_raw as (
    select ue.dt
         , coalesce(cast(substring(ue.app_id, 4, 3) as int), 0) as core
         , ue.shortplay_id as series_id
         , ue.login_id as user_id
    from ads.ads_sensors_cd_video_unlockEpisode_view ue
    join dim.dim_short_video_epis_view se
      on ue.shortplay_id = se.series_id
     and ue.episode_id = se.epis_id
     and se.is_free = 0
     and se.is_delete = 0
    where ue.dt >= '${bf_4_dt}'
      and ue.dt <= '${dt}'
      and ue.unlock_type = '8' -- 广告解锁
      and ue.project_id = '8'  -- 5阅读 8 短剧
      and ue.shortplay_id is not null
      and ue.login_id is not null

    union all

    select cb.dt
         , coalesce(ed.corever, 0) as core
         , cb.series_id
         , cb.account_id as user_id
    from dwd.dwd_sv_consume_user_consume_bill_pdi cb
    join dim.dim_short_video_epis_view se
      on cb.series_id = se.series_id
     and cb.epis_id = se.epis_id
     and se.is_free = 0
     and se.is_delete = 0
    join dws.dws_user_short_video_wide_active_period_ed ed
      on cb.dt = ed.dt
     and cb.account_id = ed.user_id
     and ed.period_type = 'ctt'
    where cb.dt >= '${bf_4_dt}'
      and cb.dt <= '${dt}'
      and cb.series_id is not null
      and cb.account_id is not null

    union all

    select dt
         , coalesce(cast(corever2 as int), 0) as core
         , get_json_int(custom_data, '$.seriesId') as series_id
         , user_id
    from ads.ads_short_video_payorder_view
    where dt >= '${bf_4_dt}'
      and dt <= '${dt}'
      and shop_item in (810, 860)
      and get_json_int(custom_data, '$.seriesId') is not null
      and user_id is not null
),

-- 本剧直充用户数
unlock_stat as (
    select ur.dt
         , ur.core
         , case when du.user_id is not null then 1 else 0 end as acquisition_source_cd
         , ur.series_id
         -- 本剧直充用户数
         , bitmap_agg(ur.user_id) as series_charge_user
    from unlock_raw ur
    left join dl_user_set du
      on ur.series_id = du.series_id
     and ur.user_id = du.user_id
    group by 1, 2, 3, 4
)

-- 最终输出
select s.dt                                 as dt
     , s.core
     , s.acquisition_source_cd
     , s.language_code
     , s.series_id
     , dic.cd_val_desc                      as language_name
     , v.series_code
     , v.series_name
     , v.all_epis
     , v.cover_url
     , sa.series_level
     , sa.series_level_name
     , sta.series_type_labels
     , sa.work_type
     , sa.work_type_name
     , sa.local_type
     , sa.local_type_name
     , sa.local_sub_type
     , sa.local_sub_type_name
     , sa.audio_type
     , sa.audio_type_name
     , sa.dubbed_type
     , sa.dubbed_type_name
     , v.publish_edat                       as publish_time
     , se.series_duration                   as series_duration
     , se.first_pay_epis_num                as first_pay_epis_num
     , ls.epis3_watch_user
     , ls.epis3_loss_user
     , ls.paid_prev_watch_user
     , ls.paid_loss_user
     -- 点击曝光
     , coalesce(ce.click_num, 0)            as click_num
     , coalesce(ce.exposure_num, 0)         as exposure_num
     -- bitmap指标
     , s.first_epis_complete_user
     , s.first_epis_total_user
     , s.loss_10s_user
     , s.exit_5s_user
     , s.complete_10s_user
     , s.complete_10min_user
     , s.complete_30min_user
     , s.complete_60min_user
     , s.complete_series_user
     -- 播放指标
     , coalesce(s.total_play_epis_count, 0) as total_play_epis_count
     , coalesce(s.total_play_duration, 0)   as total_play_duration
     , s.play_user
     , coalesce(p.play_count, 0)            as play_count
     , es.unlock_user                       as series_unlock_user
     , us.series_charge_user
     , es.unlock_epis                       as total_unlock_epis_cnt
     , now() as etl_time
from series_stat s
left join dim.dim_short_video_series_view v
  on s.series_id = v.series_id
left join series_attr sa
  on s.series_id = sa.series_id
left join series_type_agg sta
  on s.series_id = sta.series_id
left join dim.dim_pub_code_mapping_dict dic
  on dic.app_plat = 'pub'
 and dic.cd_col = 'lang_cd'
 and dic.cd_val = s.language_code
left join play_count_stat                     p
  on s.dt = p.dt
 and s.core = p.core
 and s.acquisition_source_cd = p.acquisition_source_cd
 and s.language_code = p.language_code
 and s.series_id = p.series_id
left join click_exposure_stat                 ce
  on s.dt = ce.dt
 and s.core = ce.core
 and s.acquisition_source_cd = ce.acquisition_source_cd
 and s.language_code = ce.language_code
 and s.series_id = ce.series_id
left join epis_stat es
  on s.dt = es.dt
 and s.core = es.core
 and s.acquisition_source_cd = es.acquisition_source_cd
 and s.language_code = es.language_code
 and s.series_id = es.series_id
left join unlock_stat us
  on s.dt = us.dt
 and s.core = us.core
 and s.acquisition_source_cd = us.acquisition_source_cd
 and s.series_id = us.series_id
left join series_pay_boundary se
  on s.series_id = se.series_id
left join loss_stat ls
  on s.dt = ls.dt
 and s.core = ls.core
 and s.acquisition_source_cd = ls.acquisition_source_cd
 and s.language_code = ls.language_code
 and s.series_id = ls.series_id
;
