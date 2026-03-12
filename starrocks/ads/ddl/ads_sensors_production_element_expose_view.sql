create or replace view ads.ads_sensors_production_element_expose_view(
     dt                       comment "分区日期"
    ,id                       comment "nvl(rid,track_id)"
    ,track_id                 comment "跟踪id"
    ,rid                      comment "记录id"
    ,event_tm                 comment "事件时间"
    ,device_id                comment "设备id"
    ,login_id                 comment "login_id"
    ,identity_login_id        comment "identity_login_id"
    ,device_lang              comment "设备语言"
    ,event                    comment "事件"
    ,distinct_id              comment "distinct_id"
    ,identity_user_id         comment "identity_userid"
    ,app_product_id           comment "包体id"
    ,send_id                  comment "转化来源"
    ,app_core_ver             comment "core"
    ,app_channel              comment "渠道编号"
    ,app_product_x            comment "应用程序id"
    ,app_lang_id              comment "界面语言"
    ,page_name                comment "页面名称"
    ,page_id                  comment "页面id"
    ,element_name             comment "控件名称"
    ,element_id               comment "控件id"
    ,payment_method           comment "支付方式"
    ,type                     comment "类型"
    ,activity_id              comment "活动id"
    ,parent_group_id          comment "用户集合id"
    ,group_id                 comment "用户分组id"
    ,activity_link            comment "活动链路"
    ,pay_link                 comment "支付链路"
    ,reg_language             comment "注册时语言"
    ,os                       comment "操作系统"
    ,ad_group_id              comment "广告人群包id"
    ,ad_strategy_id           comment "广告策略id"
    ,ad_position_id           comment "广告位置id"
    ,type2                    comment "类型2"
    ,module_channel_id        comment "频道id"
    ,programme_id             comment "方案id"
    ,click_content            comment "点击内容"
    ,event_strategy_id        comment "策略id"
    ,main_strategy_id         comment "主策略id"
    ,app_module               comment "模块"
    ,book_category_id_list    comment "书籍分类id列表"
    ,zffs_strategy_id         comment "支付方式策略id"
    ,zffs_id_list             comment "支付方式id列表"
    ,etl_tm                   comment "数据清洗时间"
    ,ad_src                   comment "广告来源"
    ,appCoreVer               comment "海阅新core值"
    ,dollar_app_id            comment "海剧海阅共用，可转换为core值"
)
comment "event=element_expose 控件曝光事件"
as
select a1.dt                                          as dt                       -- 分区日期
      ,a1.id                                          as id                       -- nvl(rid,track_id)
      ,a1.track_id                                    as track_id                 -- 跟踪id
      ,a1.rid                                         as rid                      -- 记录id
      ,a1.event_tm                                    as event_tm                 -- 事件时间
      ,a1.device_id                                   as device_id                -- 设备id
      ,a1.login_id                                    as login_id                 -- login_id
      ,a1.identity_login_id                           as identity_login_id        -- identity_login_id
      ,a1.device_lang                                 as device_lang              -- 设备语言
      ,a1.event                                       as event                    -- 事件
      ,a1.distinct_id                                 as distinct_id              -- distinct_id
      ,a1.identity_user_id                            as identity_user_id         -- identity_userid
      ,a1.app_product_id                              as app_product_id           -- 包体id
      ,a1.send_id                                     as send_id                  -- 转化来源
      ,coalesce(a1.app_core_ver, a1.appCoreVer)       as app_core_ver             -- core
      ,a1.app_channel                                 as app_channel              -- 渠道编号
      ,a1.app_product_x                               as app_product_x            -- 应用程序id
      ,a1.app_lang_id                                 as app_lang_id              -- 界面语言
      ,a1.page_name                                   as page_name                -- 页面名称
      ,a1.page_id                                     as page_id                  -- 页面id
      ,a1.element_name                                as element_name             -- 控件名称
      ,a1.element_id                                  as element_id               -- 控件id
      ,a1.payment_method                              as payment_method           -- 支付方式
      ,a1.type                                        as type                     -- 类型
      ,a1.activity_id                                 as activity_id              -- 活动id
      ,a1.parent_group_id                             as parent_group_id          -- 用户集合id
      ,a1.group_id                                    as group_id                 -- 用户分组id
      ,a1.activity_link                               as activity_link            -- 活动链路
      ,a1.pay_link                                    as pay_link                 -- 支付链路
      ,a2.current_language2                           as reg_language             -- 注册时语言
      ,a1.os                                          as os                       -- 操作系统
      ,a1.ad_group_id                                 as ad_group_id              -- 广告人群包id
      ,a1.ad_strategy_id                              as ad_strategy_id           -- 广告策略id
      ,a1.ad_position_id                              as ad_position_id           -- 广告位置id
      ,a1.type2                                       as type2                    -- 类型2
      ,a1.module_channel_id                           as module_channel_id        -- 频道id
      ,a1.programme_id                                as programme_id             -- 方案id
      ,a1.click_content                               as click_content            -- 点击内容
      ,a1.event_strategy_id                           as event_strategy_id        -- 策略id
      ,a1.main_strategy_id                            as main_strategy_id         -- 主策略id
      ,a1.app_module                                  as app_module               -- 模块
      ,a1.book_category_id_list                       as book_category_id_list    -- 书籍分类id列表
      ,a1.zffs_strategy_id                            as zffs_strategy_id         -- 支付方式策略id
      ,a1.zffs_id_list                                as zffs_id_list             -- 支付方式id列表
      ,a1.etl_tm                                      as etl_tm                   -- 数据清洗时间
      ,if(a1.type='123' and a1.element_id='100772'
         ,'10'
         ,a1.ad_source
         )                                            as ad_source                -- 广告来源
      ,a1.appCoreVer                                  as appCoreVer               -- 海阅新core值
      ,a1.dollar_app_id                               as dollar_app_id            -- 海剧海阅共用，可转换为core值
  from ods_log.ods_sensors_production_element_expose    as a1
  left join dim.dim_user_account_info_view              as a2
    on a1.app_product_id = a2.product_id
   and a1.identity_user_id = a2.id
;