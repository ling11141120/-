----------------------------------------------------------------
-- 程序功能： 北斗短剧来源统计表
-- 程序名： P_ads_sv_beidou_series_source_stat_di
-- 目标表： ads.ads_sv_beidou_series_source_stat_di
-- 负责人： roger
-- 开发日期：2026-01-26
-- 版本号： v1.0
----------------------------------------------------------------

insert into ads.ads_sv_beidou_series_source_stat_di
with yinliu_tmp as (
    select lv.series_id
         , b.user_id
    from ads.ads_short_video_video_dl_log_view lv
    left join dim.dim_short_video_user_accountinfo b
      on lv.unique_cdreader_id = b.unique_cdreader_id
    where lv.has_open = 1
      and lv.create_time >= date_add(cast('${dt}' as datetime), -200)
      and lv.create_time <= cast('${dt}' as datetime)
    group by 1, 2
),
series_time_attr as (
    select series_id
         , max(publish_time)   as publish_time
         , max(placement_time) as placement_time
    from dim.dim_sv_beidou_serices_detail_df
    group by series_id
),
stat_tmp as (
    select dt
         , coalesce(core, 0)              as core
         , acquisition_source_cd
         , coalesce(language_code, 0)     as language_code
         , shortplay_id                   as series_id
         , source
         , sum(startwatching_num)         as startwatching_num
         , sum(exposure_num)              as exposure_num
    from (select s.dt
               , s.core
               , case when t.user_id is not null then 1 else 0 end as acquisition_source_cd
               , coalesce(sv.language, 0) as language_code
               , coalesce(shortplay_id, split(activity_link, '_')[8]) as shortplay_id
               , case
                     when t.user_id is not null then 'DL拉剧'
                     when split(activity_link, '_')[1] = 202100
                         and split(activity_link, '_')[2] in (0, 1) then '普通弹窗'
                     when split(activity_link, '_')[1] = 202100
                         and split(activity_link, '_')[2] = 3       then '充值返回推'
                     when split(activity_link, '_')[1] = 202100
                         and split(activity_link, '_')[2] = 4       then '剧末推'
                     when split(activity_link, '_')[1] = 202100
                         and split(activity_link, '_')[2] = 9       then '退出观看返回推'
                     when split(activity_link, '_')[1] = 203200     then '悬浮窗'
                     when split(activity_link, '_')[1] = 204000     then 'TAB栏'
                     when split(activity_link, '_')[1] = 204100     then 'banner'
                     when split(activity_link, '_')[1] = 210010     then 'push'
                     when split(activity_link, '_')[1] = 210007     then '串剧'
                     when split(activity_link, '_')[1] = 203600     then '开屏页'
                     when split(activity_link, '_')[1] = 200200     then '首页'
                     when split(activity_link, '_')[1] = 200100     then '追剧页'
                     when split(activity_link, '_')[1] = 200400     then '浏览历史页'
                     when split(activity_link, '_')[1] = 201500     then '剧集解锁记录'
                     when split(activity_link, '_')[1] = 200700     then '搜索页'
                     when split(activity_link, '_')[1] = 203900     then '搜索中间页'
                     when split(activity_link, '_')[1] = 203100     then '我的评论页'
                     when split(activity_link, '_')[1] = 204600     then 'edm'
                     when split(activity_link, '_')[1] = 204700     then 'for you'
                     else '' end as source
               , count(1) as startwatching_num
               , 0        as exposure_num
           from ads.ads_sensors_cd_video_startwatching_view s
           left join dim.dim_short_video_series_view sv
             on coalesce(s.shortplay_id, split(s.activity_link, '_')[8]) = sv.series_id
           left join yinliu_tmp t
             on coalesce(shortplay_id, split(activity_link, '_')[8]) = t.series_id
            and s.login_id = t.user_id
          where dt >= '${bf_1_dt}'
            and dt <= '${dt}'
          group by 1, 2, 3, 4, 5, 6

          union all
          select e.dt
               , e.core
               , case when t.user_id is not null then 1 else 0 end as acquisition_source_cd
               , coalesce(sv.language, 0) as language_code
               , split(activity_link, '_')[8] as shortplay_id -- 解析为 series_id 短剧ID
               , case
                     when t.user_id is not null then 'DL拉剧'
                     when split(activity_link, '_')[1] = 202100
                         and split(activity_link, '_')[2] in (0, 1) then '普通弹窗'
                     when split(activity_link, '_')[1] = 202100
                         and split(activity_link, '_')[2] = 3       then '充值返回推'
                     when split(activity_link, '_')[1] = 202100
                         and split(activity_link, '_')[2] = 4       then '剧末推'
                     when split(activity_link, '_')[1] = 202100
                         and split(activity_link, '_')[2] = 9       then '退出观看返回推'
                     when split(activity_link, '_')[1] = 203200     then '悬浮窗'
                     when split(activity_link, '_')[1] = 204000     then 'TAB栏'
                     when split(activity_link, '_')[1] = 204100     then 'banner'
                     when split(activity_link, '_')[1] = 210010     then 'push'
                     when split(activity_link, '_')[1] = 210007     then '串剧'
                     when split(activity_link, '_')[1] = 203600     then '开屏页'
                     when split(activity_link, '_')[1] = 200200     then '首页'
                     when split(activity_link, '_')[1] = 200100     then '追剧页'
                     when split(activity_link, '_')[1] = 200400     then '浏览历史页'
                     when split(activity_link, '_')[1] = 201500     then '剧集解锁记录'
                     when split(activity_link, '_')[1] = 200700     then '搜索页'
                     when split(activity_link, '_')[1] = 203900     then '搜索中间页'
                     when split(activity_link, '_')[1] = 203100     then '我的评论页'
                     when split(activity_link, '_')[1] = 204600     then 'edm'
                     when split(activity_link, '_')[1] = 204700     then 'for you'
                     else '' end as source
               , 0        as startwatching_num
               , count(1) as exposure_num
           from ads.ads_sensors_cd_video_operationpositionexposure_view e
           left join dim.dim_short_video_series_view sv
             on split(e.activity_link, '_')[8] = sv.series_id
           left join yinliu_tmp t
             on split(activity_link, '_')[8] = t.series_id
            and e.login_id = t.user_id
          where dt >= '${bf_1_dt}'
            and dt <= '${dt}'
            and split(activity_link, '_')[8] != 0 -- 解析为 series_id 短剧ID
          group by 1, 2, 3, 4, 5, 6
         ) tb
    -- 过滤掉 source 为空的数据
    where source != ''
    group by 1, 2, 3, 4, 5, 6
)

select s.dt
     , s.core
     , s.acquisition_source_cd
     , s.language_code
     , s.series_id
     , s.source
     , dic.cd_val_desc as language_name
     , v.series_code
     , v.series_name
     , sta.publish_time
     , sta.placement_time
     , s.startwatching_num
     , s.exposure_num
     , now()           as etl_time
from stat_tmp s
     left join dim.dim_short_video_series_view v
        on s.series_id = v.series_id
     left join series_time_attr sta
        on cast(s.series_id as bigint) = sta.series_id
     left join dim.dim_pub_code_mapping_dict dic
        on dic.app_plat = 'pub'
       and dic.cd_col = 'lang_cd'
       and dic.cd_val = s.language_code
where coalesce(s.startwatching_num, 0) + coalesce(s.exposure_num, 0) > 0
      and cast(s.series_id as bigint) is not null
;
