create or replace view dwd.dwd_sensors_production_element_click_view (
     dt                       comment "分区日期"
    ,id                       comment "nvl (rid,track_id)"
    ,track_id                 comment "跟踪id"
    ,rid                      comment "记录id"
    ,event_tm                 comment "事件时间"
    ,device_id                comment "设备id"
    ,login_id                 comment "登录id"
    ,identity_login_id        comment "登录验证id"
    ,device_lang              comment "设备语言"
    ,event                    comment "事件"
    ,distinct_id              comment "distinct_id"
    ,identity_user_id         comment "登录验证用户id"
    ,app_product_id           comment "包体 id"
    ,send_id                  comment "转化来源"
    ,app_core_ver             comment "core"
    ,mt                       comment "平台"
    ,appver                   comment "app版本号"
    ,app_channel              comment "渠道编号"
    ,app_product_x            comment "应用程序id"
    ,app_lang_id              comment "界面语言"
    ,page_name                comment "页面名称"
    ,page_id                  comment "页面id"
    ,element_name             comment "控件名称"
    ,element_id               comment "控件id"
    ,payment_method           comment "支付方式"
    ,type                     comment "类型"
    ,element_content          comment "点击元素内容"
    ,activity_id              comment "活动id"
    ,parent_group_id          comment "用户集合id"
    ,group_id                 comment "用户分组id"
    ,etl_tm                   comment "清洗时间"
    ,ad_position_id           comment "广告位置id"
    ,activity_link            comment "活动链路"
    ,pay_link                 comment "支付链路"
    ,os                       comment "操作系统"
    ,ad_group_id              comment "广告人群包 id"
    ,ad_strategy_id           comment "广告策略 id"
    ,read_source_page_name    comment "原始页面名称"
    ,module_channel_id        comment "频道 id"
    ,programme_id             comment "方案 id"
    ,event_strategy_id        comment "策略 id"
    ,main_strategy_id         comment "主策略 id"
    ,ad_src                   comment "广告来源"
    ,appCoreVer               comment "海阅新core值"
    ,dollar_app_id            comment "海剧海阅共用，可转换为core值"
    ,app_id                   comment "海剧海阅app_id"
)
comment "event=element_click 控件点击时上报"
as
select
     a1.dt                                      as dt                       -- 分区日期
    ,a1.id                                      as id                       -- nvl(rid,track_id)
    ,a1.track_id                                as track_id                 -- 跟踪id
    ,a1.rid                                     as rid                      -- 记录 ID
    ,a1.event_tm                                as event_tm                 -- 事件时间
    ,a1.device_id                               as device_id                -- 设备 id
    ,a1.login_id                                as login_id                 -- login_id
    ,a1.identity_login_id                       as identity_login_id        -- identity_login_id
    ,a1.device_lang                             as device_lang              -- 设备语言
    ,a1.event                                   as event                    -- 事件
    ,a1.distinct_id                             as distinct_id              -- distinct_id
    ,a1.identity_user_id                        as identity_user_id         -- identity_userid
    ,if(coalesce(a1.app_core_ver,a1.appCoreVer)=4
        ,'3366'
        ,coalesce(a1.app_core_ver,a1.appCoreVer)
       )                                        as app_product_id           -- 包体 ID
    ,a1.send_id                                 as send_id                  -- 转化来源
    ,coalesce(a1.app_core_ver,a1.appCoreVer)    as app_core_ver             -- core
    ,a1.lib                                     as mt                       -- 平台
    ,a1.app_version                             as appver                   -- app 版本号
    ,a1.app_channel                             as app_channel              -- 渠道编号
    ,a1.app_product_x                           as app_product_x            -- 应用程序 ID
    ,a1.app_lang_id                             as app_lang_id              -- 界面语言
    ,a1.page_name                               as page_name                -- 页面名称
    ,a1.page_id                                 as page_id                  -- 页面 ID
    ,a1.element_name                            as element_name             -- 控件名称
    ,a1.element_id                              as element_id               -- 控件 ID
    ,a1.payment_method                          as payment_method           -- 支付方式
    ,if(a1.type = 'track', null, a1.type)       as type                     -- 类型
    ,a1.element_content                         as element_content          -- 点击元素内容
    ,a1.activity_id                             as activity_id              -- 活动 ID
    ,a1.parent_group_id                         as parent_group_id          -- 用户集合 ID
    ,a1.group_id                                as group_id                 -- 用户分组 ID
    ,a1.etl_tm                                  as etl_tm                   -- 清洗时间
    ,a1.ad_position_id                          as ad_position_id           -- 广告位置 id
    ,a1.activity_link                           as activity_link            -- 活动链路
    ,a1.pay_link                                as pay_link                 -- 支付链路
    ,a1.os                                      as os                       -- 操作系统
    ,a1.ad_group_id                             as ad_group_id              -- 广告人群包 ID
    ,a1.ad_strategy_id                          as ad_strategy_id           -- 广告策略 ID
    ,a1.read_source_page_name                   as read_source_page_name    -- 读取来源页面名称
    ,a1.module_channel_id                       as module_channel_id        -- 频道 ID
    ,a1.programme_id                            as programme_id             -- 方案 ID
    ,a1.event_strategy_id                       as event_strategy_id        -- 策略 ID
    ,a1.main_strategy_id                        as main_strategy_id         -- 主策略 ID
    ,a1.add_source                              as ad_src                   -- 广告来源
    ,a1.appCoreVer                              as appCoreVer               -- 海阅新core值
    ,a1.dollar_app_id                           as dollar_app_id            -- 海剧海阅共用，可转换为core值
    ,coalesce(a1.app_id,a1.appId)               as app_id                   -- 海剧海阅app_id
  from ods_log.ods_sensors_production_element_click    as a1
;