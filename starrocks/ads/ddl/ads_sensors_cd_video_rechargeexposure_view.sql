create or replace view ads.ads_sensors_cd_video_rechargeexposure_view (
    dt                       comment "分区日期"
   ,id                       comment "nvl(rid,track_id)"
   ,track_id                 comment "跟踪id"
   ,rid                      comment "记录id"
   ,event_tm                 comment "事件时间"
   ,device_id                comment "设备id"
   ,login_id                 comment "登录id"
   ,identity_login_id        comment "身份登录id"
   ,device_lang              comment "设备语言"
   ,event                    comment "事件"
   ,distinct_id              comment "distinct id"
   ,identity_user_id         comment "身份用户id"
   ,app_product_id           comment "包体ID"
   ,send_id                  comment "转化来源"
   ,app_core_ver             comment "core版本"
   ,app_channel              comment "渠道编号"
   ,app_product_x            comment "应用程序ID"
   ,app_lang_id              comment "界面语言"
   ,page_name                comment "页面名称"
   ,page_id                  comment "页面ID"
   ,element_name             comment "控件名称"
   ,element_id               comment "控件ID"
   ,recharge_type            comment "充值类型"
   ,book_id                  comment "小说ID"
   ,chapter_id               comment "章节id"
   ,recharge_amount          comment "充值货币金额"
   ,present_gift             comment "赠送货币金额"
   ,countdown                comment "倒计时标签时长"
   ,real_recharge            comment "支付金额"
   ,list_sort                comment "列表位置"
   ,is_available             comment "是否可用"
   ,event_strategy_id        comment "策略id"
   ,app_module               comment "模块"
   ,element_type             comment "控件类型"
   ,czlx                     comment "充值类型"
   ,subscription_days        comment "订阅天数"
   ,programme_id             comment "方案ID"
   ,cz_template_id           comment "充值模板ID"
   ,cz_template_name         comment "充值模板名称"
   ,task_current_progress    comment "当前任务进度"
   ,task_max_progress        comment "任务最大进度"
   ,app_id                   comment "app ID"
   ,app_version              comment "应用版本"
   ,product_id               comment "产品ID"
   ,os                       comment "操作系统"
   ,core                     comment "core版本"
   ,current_language2        comment "当前语言"
   ,ip                       comment "IP"
   ,city                     comment "城市"
   ,province                 comment "省份"
   ,country                  comment "国家"
   ,lib                      comment "lib"
   ,lib_version              comment "lib版本"
   ,project_id               comment "项目ID"
   ,shortplay_id             comment "短剧id"
   ,episode_id               comment "剧集id"
   ,activity_link            comment "活动链路"
   ,pay_link                 comment "支付链路"
   ,activity_id              comment "活动id"
   ,parent_group_id          comment "用户集合ID"
   ,ad_group_id              comment "广告人群包ID"
   ,ad_strategy_id           comment "广告策略ID"
   ,main_strategy_id         comment "主策略ID"
   ,recharge_index           comment "档位位序"
   ,zffs_list                comment "支付方式列表"
   ,anonymous_id             comment "匿名id"
   ,etl_time                 comment "etl时间"
)
comment "event=rechargeExposure 充值档位曝光事件"
as
select
     a1.dt                                        as dt                       -- 分区日期
    ,a1.id                                        as id                       -- nvl(rid,track_id)
    ,a1.track_id                                  as track_id                 -- 跟踪id
    ,a1.rid                                       as rid                      -- 记录id
    ,a1.event_tm                                  as event_tm                 -- 事件时间
    ,a1.device_id                                 as device_id                -- 设备id
    ,a1.login_id                                  as login_id                 -- 登录id
    ,a1.identity_login_id                         as identity_login_id        -- 身份登录id
    ,a1.device_lang                               as device_lang              -- 设备语言
    ,a1.event                                     as event                    -- 事件
    ,a1.distinct_id                               as distinct_id              -- distinct id
    ,a1.identity_user_id                          as identity_user_id         -- 身份用户id
    ,a1.app_product_id                            as app_product_id           -- 包体ID
    ,a1.send_id                                   as send_id                  -- 转化来源
    ,a1.app_core_ver                              as app_core_ver             -- core版本
    ,a1.app_channel                               as app_channel              -- 渠道编号
    ,a1.app_product_x                             as app_product_x            -- 应用程序ID
    ,a1.app_lang_id                               as app_lang_id              -- 界面语言
    ,a1.page_name                                 as page_name                -- 页面名称
    ,a1.page_id                                   as page_id                  -- 页面ID
    ,a1.element_name                              as element_name             -- 控件名称
    ,a1.element_id                                as element_id               -- 控件ID
    ,a1.recharge_type                             as recharge_type            -- 充值类型
    ,a1.book_id                                   as book_id                  -- 小说ID
    ,a1.chapter_id                                as chapter_id               -- 章节id
    ,a1.recharge_amount                           as recharge_amount          -- 充值货币金额
    ,a1.present_gift                              as present_gift             -- 赠送货币金额
    ,a1.countdown                                 as countdown                -- 倒计时标签时长
    ,a1.real_recharge                             as real_recharge            -- 支付金额
    ,a1.list_sort                                 as list_sort                -- 列表位置
    ,a1.is_available                              as is_available             -- 是否可用
    ,a1.event_strategy_id                         as event_strategy_id        -- 事件策略id
    ,a1.app_module                                as app_module               -- 模块
    ,a1.element_type                              as element_type             -- 控件类型
    ,a1.czlx                                      as czlx                     -- 充值类型
    ,a1.subscription_days                         as subscription_days        -- 订阅天数
    ,a1.programme_id                              as programme_id             -- 方案ID
    ,a1.cz_template_id                            as cz_template_id           -- 充值模板ID
    ,a1.cz_template_name                          as cz_template_name         -- 充值模板名称
    ,a1.task_current_progress                     as task_current_progress    -- 当前任务进度
    ,a1.app_id                                    as app_id                   -- app ID
    ,a1.app_version                               as app_version              -- app版本
    ,a1.product_id                                as product_id               -- 产品ID
    ,a1.os                                        as os                       -- 操作系统
    ,cast((substring(a1.app_id, 4, 3)) as int)    as core                     -- core版本
    ,a2.currentlanguage2                          as current_language2        -- 当前语言
    ,a1.ip                                        as ip                       -- ip地址
    ,a1.city                                      as city                     -- 城市
    ,a1.province                                  as province                 -- 省份
    ,a1.country                                   as country                  -- 国家
    ,a1.lib                                       as lib                      -- lib
    ,a1.lib_version                               as lib_version              -- lib版本
    ,a1.project_id                                as project_id               -- 项目ID
    ,a1.shortplay_id                              as shortplay_id             -- 短剧ID
    ,a1.episode_id                                as episode_id               -- 剧集ID
    ,a1.activity_link                             as activity_link            -- 活动链接
    ,a1.pay_link                                  as pay_link                 -- 支付链接
    ,a1.activity_id                               as activity_id              -- 活动ID
    ,a1.parent_group_id                           as parent_group_id          -- 父级广告组ID
    ,a1.ad_group_id                               as ad_group_id              -- 广告组ID
    ,a1.ad_strategy_id                            as ad_strategy_id           -- 广告策略ID
    ,a1.main_strategy_id                          as main_strategy_id         -- 主策略ID
    ,a1.recharge_index                            as recharge_index           -- 充值索引
    ,a1.zffs_list                                 as zffs_list                -- 支付方式列表
    ,a1.anonymous_id                              as anonymous_id             -- 匿名id
    ,a1.etl_tm                                    as etl_time                 -- 数据采集时间
  from ods_log.ods_sensors_cd_video_production_rechargeexposure    as a1
  left join ods.ods_tidb_short_video_accountinfo                   as a2
    on a1.login_id = a2.id
 where a1.project_id = 8
;