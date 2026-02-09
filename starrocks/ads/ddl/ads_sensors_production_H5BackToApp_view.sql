create or replace view ads.ads_sensors_production_H5BackToApp_view(
     dt                   comment "分区日期"
    ,id                   comment "nvl(rid,track_id)"
    ,track_id             comment "跟踪id"
    ,rid                  comment "记录ID"
    ,event_tm             comment "事件时间"
    ,device_id            comment "设备id"
    ,login_id             comment "login_id"
    ,identity_login_id    comment "identity_login_id"
    ,device_lang          comment "设备语言"
    ,event                comment "事件"
    ,distinct_id          comment "distinct_id"
    ,identity_user_id     comment "identity_userid"
    ,app_product_id       comment "包体ID"
    ,send_id              comment "转化来源"
    ,app_core_ver         comment "core"
    ,app_channel          comment "渠道编号"
    ,app_product_x        comment "应用程序ID"
    ,app_lang_id          comment "界面语言"
    ,lib_version          comment "lib_version"
    ,app_version          comment "app_version"
    ,ad_position_id       comment "广告位ID"
    ,project_id           comment "5阅读 8 短剧"
    ,app_id               comment "app_id"
    ,product_id           comment "产品ID"
    ,os                   comment "操作系统"
    ,ip                   comment "IP"
    ,city                 comment "城市"
    ,app_name             comment "应用名称"
    ,status               comment "状态"
    ,task_id              comment "任务id"
    ,ad_strategy_id       comment "广告策略ID"
    ,ad_group_id          comment "广告人群包ID"
    ,event_strategy_id    comment "策略ID"
    ,main_strategy_id     comment "主策略ID"
    ,programme_id         comment "方案ID"
    ,module_channel_id    comment "频道id"
    ,etl_tm               comment "清洗时间"
    ,ad_src               comment "广告来源"
)
comment "event=H5BackToApp H5广告返回APP"
as
select dt                   as dt                   -- 分区日期
      ,id                   as id                   -- nvl(rid,track_id)
      ,track_id             as track_id             -- 跟踪id
      ,rid                  as rid                  -- 记录ID
      ,event_tm             as event_tm             -- 事件时间
      ,device_id            as device_id            -- 设备id
      ,login_id             as login_id             -- login_id
      ,identity_login_id    as identity_login_id    -- identity_login_id
      ,device_lang          as device_lang          -- 设备语言
      ,event                as event                -- 事件
      ,distinct_id          as distinct_id          -- distinct_id
      ,identity_user_id     as identity_user_id     -- identity_userid
      ,app_product_id       as app_product_id       -- 包体ID
      ,send_id              as send_id              -- 转化来源
      ,app_core_ver         as app_core_ver         -- core
      ,app_channel          as app_channel          -- 渠道编号
      ,app_product_x        as app_product_x        -- 应用程序ID
      ,app_lang_id          as app_lang_id          -- 界面语言
      ,lib_version          as lib_version          -- lib版本
      ,app_version          as app_version          -- app版本
      ,ad_position_id       as ad_position_id       -- 广告位ID
      ,project_id           as project_id           -- 5阅读 8 短剧
      ,app_id               as app_id               -- app_id
      ,product_id           as product_id           -- 产品ID
      ,os                   as os                   -- 操作系统
      ,ip                   as ip                   -- IP
      ,city                 as city                 -- 城市
      ,app_name             as app_name             -- 应用名称
      ,status               as status               -- 状态
      ,task_id              as task_id              -- 任务id
      ,ad_strategy_id       as ad_strategy_id       -- 广告策略ID
      ,ad_group_id          as ad_group_id          -- 广告人群包ID
      ,event_strategy_id    as event_strategy_id    -- 策略ID
      ,main_strategy_id     as main_strategy_id     -- 主策略ID
      ,programme_id         as programme_id         -- 方案ID
      ,module_channel_id    as module_channel_id    -- 频道id
      ,etl_tm               as etl_tm               -- 清洗时间
      ,ad_source            as ad_source            -- 广告来源
  from ods_log.ods_sensors_production_H5BackToApp    as a1
;