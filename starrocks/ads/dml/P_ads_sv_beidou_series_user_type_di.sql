----------------------------------------------------------------
-- 程序功能： 北斗短剧用户分类统计表
-- 程序名： P_ads_sv_beidou_series_user_type_di
-- 目标表： ads.ads_sv_beidou_series_user_type_di
-- 负责人： roger
-- 开发日期：2026-01-26
-- 版本号： v1.0
----------------------------------------------------------------

insert into ads.ads_sv_beidou_series_user_type_di
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

-- 当日观看用户(从底表提取唯一 dt, user, core, series)
watch_user as (
    select ew.dt
         , ew.user_id
         , ew.core
         , ew.series_id
         , case when du.user_id is not null then 1 else 0 end as acquisition_source_cd
    from epis_watch_view ew
    left join dl_user_set du
      on ew.series_id = du.series_id
     and ew.user_id = du.user_id
    group by 1, 2, 3, 4, 5
),

-- 关联短剧维表/用户表获取 language_code, country_name(core 来自 watch_user)
user_with_info as (
    select w.dt
         , w.user_id
         , w.series_id
         , w.core
         , w.acquisition_source_cd
         , coalesce(s.language, 0)              as language_code
         , coalesce(dic.cd_val_desc, 'Unknown') as country -- 国家名称(如:美国)
    from watch_user w
    left join dim.dim_short_video_series_view s
      on w.series_id = s.series_id
    left join dim.dim_short_video_user_accountinfo u
      on w.user_id = u.user_id
    left join dim.dim_pub_code_mapping_dict dic
      on dic.cd_col = 'ctry_cd'
     and dic.cd_val = u.reg_country
),

-- 用户充值类型(关联维表当日分区，获取用户类型)
-- 订阅用户：历史有订阅记录; IAP用户：有充值但未订阅; 免费用户：关联不上
user_pay_type as (
    select user_id
         , user_type                  as pay_type
         , date(first_pay_time)       as first_pay_date
         , date(first_subscribe_time) as first_subscribe_date
    from dim.dim_sv_user_pay_type_df
    where dt = (select max(dt) from dim.dim_sv_user_pay_type_df)
),

-- 用户分类聚合(按core, language_code分组)
user_type_stat as (
    select w.dt
         , w.core
         , w.acquisition_source_cd
         , w.language_code
         , w.series_id
         , case when p.pay_type is null then '免费用户'
                when w.dt >= p.first_subscribe_date then '订阅用户'
                when w.dt >= p.first_pay_date then 'IAP用户'
                else '免费用户'
            end as user_type
         , w.country
         , bitmap_agg(w.user_id) as user_count
    from user_with_info w
    left join user_pay_type p on w.user_id = p.user_id
    group by 1, 2, 3, 4, 5, 6, 7
)

-- 最终输出
select s.dt
     , s.core
     , s.acquisition_source_cd
     , s.language_code
     , s.series_id
     , s.user_type
     , s.country
     , dic.cd_val_desc as language_name
     , v.series_code
     , v.series_name
     , s.user_count
     , now() as etl_time
from user_type_stat s
left join dim.dim_short_video_series_view v
    on s.series_id = v.series_id
left join dim.dim_pub_code_mapping_dict dic
    on dic.app_plat = 'pub'
   and dic.cd_col = 'lang_cd'
   and dic.cd_val = s.language_code
;
