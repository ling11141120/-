----------------------------------------------------------------
-- 程序功能： 北斗短剧来源统计表
-- 程序名： P_ads_sv_beidou_series_source_stat_di
-- 目标表： ads.ads_sv_beidou_series_source_stat_di
-- 负责人： roger
-- 开发日期：2026-01-26
-- 版本号： v1.0
----------------------------------------------------------------

insert into ads.ads_sv_beidou_series_source_stat_di
with stat_tmp as (
    select dt
         , coalesce(core, 0)              as core
         , coalesce(current_language2, 0) as language_code
         , shortplay_id                   as series_id
         , source
         , sum(startwatching_num)         as startwatching_num
         , sum(exposure_num)              as exposure_num
    from (select dt
               , core
               , current_language2
               , coalesce(shortplay_id, split(activity_link, '_')[8]) as shortplay_id
               , case
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
                     else "" end as source
               , count(1) as startwatching_num
               , 0        as exposure_num
          from ads.ads_sensors_cd_video_startwatching_view
          where dt >= '${bf_1_dt}'
            and dt <= '${dt}'
            and current_language2 is not null
          group by 1, 2, 3, 4, 5

          union all
          select dt
               , core
               , current_language2
               , split(activity_link, '_')[8] as shortplay_id -- 解析为 series_id 短剧ID
               , case
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
                     else "" end as source
               , 0        as startwatching_num
               , count(1) as exposure_num
          from ads.ads_sensors_cd_video_operationpositionexposure_view
          where dt >= '${bf_1_dt}'
            and dt <= '${dt}'
            and current_language2 is not null
            and split(activity_link, '_')[8] != 0 -- 解析为 series_id 短剧ID
          group by 1, 2, 3, 4, 5
         ) tb
    where source != ""
    group by dt
           , core
           , current_language2
           , shortplay_id
           , source
)

select s.dt
     , s.core
     , s.language_code
     , s.series_id
     , s.source
     , dic.cd_val_desc as language_name
     , v.series_code
     , v.series_name
     , s.startwatching_num
     , s.exposure_num
     , now()           as etl_time
from stat_tmp s
     left join dim.dim_short_video_series_view v
        on s.series_id = v.series_id
     left join dim.dim_pub_code_mapping_dict dic
        on dic.app_plat = 'pub'
       and dic.cd_col = 'lang_cd'
       and dic.cd_val = s.language_code
where coalesce(s.startwatching_num, 0) + coalesce(s.exposure_num, 0) > 0
      and cast(s.series_id as bigint) is not null
;
