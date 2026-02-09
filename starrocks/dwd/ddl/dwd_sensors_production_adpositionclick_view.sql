create or replace view dwd.dwd_sensors_production_adpositionclick_view (
     dt                   comment "分区日期"
    ,id                   comment "nvl(rid,track_id)"
    ,track_id             comment "跟踪id"
    ,rid                  comment "记录id"
    ,event_tm             comment "事件时间"
    ,device_id            comment "设备id"
    ,user_id              comment "用户id"
    ,identity_login_id    comment "登录id"
    ,device_lang          comment "设备语言"
    ,event                comment "事件"
    ,distinct_id          comment "用户id"
    ,identity_user_id     comment "用户id"
    ,product_id           comment "产品id"
    ,send_id              comment "发送id"
    ,app_id               comment "应用id"
    ,core                 comment "core"
    ,mt                   comment "事件时间"
    ,app_channel          comment "应用渠道"
    ,app_product_x        comment "应用产品"
    ,current_language     comment "当前语言"
    ,lib_version          comment "库版本"
    ,appver               comment "应用版本"
    ,page_id              comment "页面id"
    ,page_name            comment "页面名称"
    ,ad_type              comment "广告类型"
    ,ad_position_id       comment "广告位置id"
    ,project_id           comment "项目id"
    ,os                   comment "操作系统"
    ,ip                   comment "IP"
    ,city                 comment "城市"
    ,element_id           comment "控件ID"
    ,element_name         comment "控件名称"
    ,element_type         comment "控件类型"
    ,event_strategy_id    comment "策略ID"
    ,parent_group_id      comment "用户集合ID"
    ,main_strategy_id     comment "主策略ID"
    ,ad_strategy_id       comment "广告策略ID"
    ,ad_group_id          comment "广告人群包ID"
    ,programme_id         comment "方案ID"
    ,module_channel_id    comment "频道id"
    ,etl_tm               comment "ETL时间"
    ,ad_src               comment "广告来源"
    ,shortplay_id         comment "短剧ID"
    ,episode_id           comment "剧集ID"
    ,appId                comment "海阅appId"
    ,dollar_app_id        comment "海剧海阅共用，可转换为core值"
)
comment "event=ADPositionClick 资源位点击"
as
select a1.dt                                                                as dt                   -- 分区日期
      ,a1.id                                                                as id                   -- nvl(rid,track_id)
      ,a1.track_id                                                          as track_id             -- 跟踪id
      ,a1.rid                                                               as rid                  -- 记录id
      ,a1.event_tm                                                          as event_tm             -- 事件时间
      ,a1.device_id                                                         as device_id            -- 设备id
      ,a1.login_id                                                          as user_id              -- 用户id
      ,a1.identity_login_id                                                 as identity_login_id    -- 登录id
      ,a1.device_lang                                                       as device_lang          -- 设备语言
      ,a1.event                                                             as event                -- 事件
      ,a1.distinct_id                                                       as distinct_id          -- 用户id
      ,a1.identity_user_id                                                  as identity_user_id     -- 用户id
      ,if (a1.project_id = 8,6833,a1.app_product_id)                        as product_id           -- 产品id
      ,a1.send_id                                                           as send_id              -- 发送id
      ,a1.app_id                                                            as app_id               -- 应用id
      ,coalesce(a1.app_core_ver,CAST((substring(a1.app_id,4,3)) AS INT))    as core                 -- core
      ,a1.lib                                                               as mt                   -- 事件时间
      ,a1.app_channel                                                       as app_channel          -- 应用渠道
      ,a1.app_product_x                                                     as app_product_x        -- 应用产品
      ,a1.app_lang_id                                                       as current_language     -- 当前语言
      ,a1.lib_version                                                       as lib_version          -- 库版本
      ,a1.app_version                                                       as appver               -- 应用版本
      ,a1.page_id                                                           as page_id              -- 页面id
      ,a1.page_name                                                         as page_name            -- 页面名称
      ,a1.ad_type                                                           as ad_type              -- 广告类型
      ,coalesce(a1.ad_position_id1,a1.ad_position_id)                       as ad_position_id       -- 广告位置id
      ,a1.project_id                                                        as project_id           -- 项目id
      ,a1.os                                                                as os                   -- 操作系统
      ,a1.ip                                                                as ip                   -- IP
      ,a1.city                                                              as city                 -- 城市
      ,a1.element_id                                                        as element_id           -- 控件ID
      ,a1.element_name                                                      as element_name         -- 控件名称
      ,a1.element_type                                                      as element_type         -- 控件类型
      ,a1.event_strategy_id                                                 as event_strategy_id    -- 事件策略ID
      ,a1.parent_group_id                                                   as parent_group_id      -- 用户集合ID
      ,a1.main_strategy_id                                                  as main_strategy_id     -- 主策略ID
      ,a1.ad_strategy_id                                                    as ad_strategy_id       -- 广告策略ID
      ,a1.ad_group_id                                                       as ad_group_id          -- 广告人群包ID
      ,a1.programme_id                                                      as programme_id         -- 方案ID
      ,a1.module_channel_id                                                 as module_channel_id    -- 频道id
      ,a1.etl_tm                                                            as etl_tm               -- ETL时间
      ,a1.ad_source                                                         as ad_src               -- 广告来源
      ,a1.shortplay_id                                                      as shortplay_id         -- 短剧ID
      ,a1.episode_id                                                        as episode_id           -- 剧集ID
      ,a1.appId                                                             as appId                -- 海阅appId
      ,a1.dollar_app_id                                                     as dollar_app_id        -- 海剧海阅共用，可转换为core值
  from ods_log.ods_sensors_production_adpositionclick    as a1
;