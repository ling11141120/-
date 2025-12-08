create or replace view ads.ads_sensors_cd_video_startwatching_view (
     dt                          comment "日期"
    ,id                          comment "主键"
    ,rid                         comment "记录ID"
    ,track_id                    comment "track_id"
    ,event                       comment "事件"
    ,event_tm                    comment "事件时间"
    ,app_channel                 comment "渠道编号"
    ,app_id                      comment "app_id"
    ,app_lang_id                 comment "界面语言"
    ,device_lang                 comment "设备语言"
    ,login_id                    comment "用户ID"
    ,product_id                  comment "产品ID"
    ,app_version                 comment "应用版本"
    ,os                          comment "操作系统"
    ,core                        comment "core版本，目前有1，2，3"
    ,current_language2           comment "注册时语言"
    ,ip                          comment "IP"
    ,city                        comment "城市"
    ,province                    comment "省份"
    ,country                     comment "国家"
    ,shortplay_id                comment "短剧ID"
    ,if_first_watch_shortplay    comment "短剧是否首次观看"
    ,episode_id                  comment "剧集ID"
    ,watch_episode_sort          comment "内容页剧集ID序号"
    ,watch_source_id             comment "观看来源控件id"
    ,watch_source_name           comment "观看来源控件名称"  
    ,watch_source_page_id        comment "观看来源页面id"
    ,watch_source_page_name      comment "观看来源页面名称"
    ,watch_speeds                comment "观看倍速"
    ,send_id                     comment "发送ID"
    ,activity_link               comment "活动链路"
    ,anonymous_id                comment "匿名ID"
    ,etl_tm                      comment "清洗时间"
)
comment "event=startWatching 开始观看"
as  
select a1.dt                                        as dt                          -- 日期
      ,a1.id                                        as id                          -- 主键
      ,a1.rid                                       as rid                         -- 记录ID
      ,a1.track_id                                  as track_id                    -- track_id
      ,a1.event                                     as event                       -- 事件
      ,a1.event_tm                                  as event_tm                    -- 事件时间
      ,a1.app_channel                               as app_channel                 -- 渠道编号
      ,a1.app_id                                    as app_id                      -- app_id
      ,a1.app_lang_id                               as app_lang_id                 -- 界面语言
      ,a1.device_lang                               as device_lang                 -- 设备语言
      ,a1.login_id                                  as login_id                    -- 用户ID
      ,a1.product_id                                as product_id                  -- 产品ID
      ,a1.app_version                               as app_version                 -- 应用版本
      ,a1.os                                        as os                          -- 操作系统
      ,cast((substring(a1.app_id, 4, 3)) as int)    as core                        -- core版本，目前有1，2，3
      ,a2.CurrentLanguage2                          as current_language2           -- 注册时语言
      ,a1.ip                                        as ip                          -- IP
      ,a1.city                                      as city                        -- 城市
      ,a1.province                                  as province                    -- 省份
      ,a1.country                                   as country                     -- 国家
      ,a1.shortplay_id                              as shortplay_id                -- 短剧ID
      ,a1.if_first_watch_shortplay                  as if_first_watch_shortplay    -- 短剧是否首次观看
      ,a1.episode_id                                as episode_id                  -- 剧集ID
      ,a1.watch_episode_sort                        as watch_episode_sort          -- 内容页剧集ID序号
      ,a1.watch_source_id                           as watch_source_id             -- 观看来源控件id
      ,a1.watch_source_name                         as watch_source_name           -- 观看来源控件名称
      ,a1.watch_source_page_id                      as watch_source_page_id        -- 观看来源页面id
      ,a1.watch_source_page_name                    as watch_source_page_name      -- 观看来源页面名称
      ,a1.watch_speeds                              as watch_speeds                -- 观看倍速
      ,a1.send_id                                   as send_id                     -- 发送ID
      ,a1.activity_link                             as activity_link               -- 活动链路
      ,a1.anonymous_id                              as anonymous_id                -- 匿名ID
      ,a1.etl_tm                                    as etl_tm                      -- 清洗时间
  from ods_log.ods_sensors_cd_video_startwatching    as a1
  left join ods.ods_tidb_short_video_accountinfo     as a2
    on a1.login_id = a2.Id
;