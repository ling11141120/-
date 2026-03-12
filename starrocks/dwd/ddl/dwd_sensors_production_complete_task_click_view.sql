create or replace view dwd.dwd_sensors_production_complete_task_click_view (
     dt                   comment "分区日期"
    ,id                   comment "nvl (rid,track_id)"
    ,track_id             comment "跟踪id"
    ,rid                  comment "记录ID"
    ,event_tm             comment "事件时间"
    ,device_id            comment "设备ID"
    ,login_id             comment "登录id"
    ,identity_login_id    comment "验证登录id"
    ,device_lang          comment "设备语言"
    ,event                comment "事件"
    ,distinct_id          comment "distinct_id"
    ,identity_user_id     comment "用户id"
    ,app_product_id       comment "包体ID"
    ,send_id              comment "转化来源"
    ,app_core_ver         comment "core"
    ,mt                   comment "平台"
    ,appver               comment "app版本号"
    ,app_channel          comment "渠道编号"
    ,app_product_x        comment "应用程序ID"
    ,app_lang_id          comment "界面语言"
    ,page_name            comment "页面名称"
    ,page_id              comment "页面ID"
    ,element_name         comment "控件名称"
    ,element_id           comment "控件ID"
    ,type                 comment "类型"
    ,parent_group_id      comment "用户集合ID"
    ,group_id             comment "用户分组ID"
    ,event_strategy_id    comment "策略ID"
    ,etl_tm               comment "etl_tm"
    ,task_type            comment "任务类型"
    ,corever              comment "corever"
    ,ad_src               comment "广告来源"
    ,appCoreVer           comment "海阅新core值"
    ,dollar_app_id        comment "海剧海阅共用，可转换为core值"
)
comment "event=completeTaskClick 控件点击时上报"
as
select a1.dt                                      as dt                   -- 分区日期
      ,a1.id                                      as id                   -- nvl (rid,track_id)
      ,a1.track_id                                as track_id             -- 跟踪id
      ,a1.rid                                     as rid                  -- 记录ID
      ,a1.event_tm                                as event_tm             -- 事件时间
      ,a1.device_id                               as device_id            -- 设备ID
      ,a1.login_id                                as login_id             -- 登录id
      ,a1.identity_login_id                       as identity_login_id    -- 验证登录id
      ,a1.device_lang                             as device_lang          -- 设备语言
      ,a1.event                                   as event                -- 事件
      ,a1.distinct_id                             as distinct_id          -- distinct_id
      ,a1.identity_user_id                        as identity_user_id     -- 用户id
      ,a1.app_product_id                          as app_product_id       -- 包体ID
      ,a1.send_id                                 as send_id              -- 转化来源
      ,coalesce(a1.app_core_ver,a1.appCoreVer)    as app_core_ver         -- core
      ,a1.lib                                     as mt                   -- 平台
      ,a1.app_version                             as appver               -- app版本号
      ,a1.app_channel                             as app_channel          -- 渠道编号
      ,a1.app_product_x                           as app_product_x        -- 应用程序ID
      ,a1.app_lang_id                             as app_lang_id          -- 界面语言
      ,a1.page_name                               as page_name            -- 页面名称
      ,a1.page_id                                 as page_id              -- 页面ID
      ,a1.element_name                            as element_name         -- 控件名称
      ,a1.element_id                              as element_id           -- 控件ID
      ,a1.type                                    as type                 -- 类型
      ,a1.parent_group_id                         as parent_group_id      -- 用户集合ID
      ,a1.group_id                                as group_id             -- 用户分组ID
      ,a1.event_strategy_id                       as event_strategy_id    -- 策略ID
      ,a1.etl_tm                                  as etl_tm               -- etl_tm
      ,a1.task_type                               as task_type            -- 任务类型
      ,a1.corever                                 as corever              -- corever
      ,if(a1.type='123' and a1.element_id='100772'
         ,'10'
         ,a1.add_source
         )                                        as ad_src               -- 广告来源
      ,a1.appCoreVer                              as appCoreVer           -- 海阅新core值
      ,a1.dollar_app_id                           as dollar_app_id        -- 海剧海阅共用，可转换为core值
  from ods_log.ods_sensors_production_complete_task_click    as a1
;