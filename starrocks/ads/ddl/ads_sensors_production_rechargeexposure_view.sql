create or replace view ads.ads_sensors_production_rechargeexposure_view (
     dt                   comment "分区日期"
    ,id                   comment "nvl(rid,track_id)"
    ,track_id             comment "track_id"
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
    ,page_name            comment "页面名称"
    ,page_id              comment "页面ID"
    ,element_name         comment "控件名称"
    ,element_id           comment "控件ID"
    ,recharge_type        comment "充值类型"
    ,book_id              comment "小说ID"
    ,chapter_id           comment "章节id"
    ,recharge_amount      comment "充值货币金额"
    ,present_gift         comment "赠送货币金额"
    ,countdown            comment "倒计时标签时长"
    ,real_recharge        comment "支付金额"
    ,list_sort            comment "列表位置"
    ,is_available         comment "是否可用"
    ,event_strategy_id    comment "策略id"
    ,app_module           comment "模块"
    ,element_type         comment "控件类型"
    ,czlx                 comment "充值类型"
    ,subscription_days    comment "订阅天数"
    ,mt                   comment "平台"
    ,subscribe_mode       comment "订阅模式"
    ,total_periods        comment "总期数"
    ,programme_id         comment "方案ID"
    ,cz_template_id       comment "充值模板ID"
    ,cz_template_name     comment "充值模板名称"
    ,task_current_progress comment "当前任务进度"
    ,task_max_progress    comment "任务最大进度"
    ,app_id               comment "app ID"
    ,app_version          comment "应用版本"
    ,product_id           comment "产品ID"
    ,os                   comment "操作系统"
    ,ip                   comment "IP"
    ,city                 comment "城市"
    ,province             comment "省份"
    ,country              comment "国家"
    ,lib                  comment "lib"
    ,lib_version          comment "5阅读 8短剧"
    ,project_id           comment "5阅读 8短剧"
    ,activity_link        comment "活动链路"
    ,pay_link             comment "支付链路"
    ,activity_id          comment "活动id"
    ,parent_group_id      comment "用户集合ID"
    ,reg_language         comment "注册语言"
    ,ad_group_id          comment "广告人群包ID"
    ,ad_strategy_id       comment "广告策略ID"
    ,main_strategy_id     comment "主策略ID"
    ,module_channel_id    comment "频道id"
    ,recharge_index       comment "档位位序"
    ,zffs_list            comment "支付方式列表"
    ,is_subscription      comment "是否续订"
    ,zffs_id_list         comment "支付方式ID列表"
    ,zffs_strategy_id     comment "支付方式策略ID"
    ,etl_tm               comment "ETL时间"
)
as
select a.dt
     , a.id
     , a.track_id
     , a.rid
     , a.event_tm
     , a.device_id
     , a.login_id
     , a.identity_login_id
     , a.device_lang
     , a.event
     , a.distinct_id
     , a.identity_user_id
     , a.app_product_id
     , a.send_id
     , a.app_core_ver
     , a.app_channel
     , a.app_product_x
     , a.app_lang_id
     , a.page_name
     , a.page_id
     , a.element_name
     , a.element_id
     , a.recharge_type
     , a.book_id
     , a.chapter_id
     , a.recharge_amount
     , a.present_gift
     , a.countdown
     , a.real_recharge
     , a.list_sort
     , a.is_available
     , a.event_strategy_id
     , a.app_module
     , a.element_type
     , a.czlx
     , a.subscription_days
     , a.mt
     , a.subscribe_mode
     , a.total_periods
     , a.programme_id
     , a.cz_template_id
     , a.cz_template_name
     , a.task_current_progress
     , a.task_max_progress
     , a.app_id
     , a.app_version
     , a.product_id
     , a.os
     , a.ip
     , a.city
     , a.province
     , a.country
     , a.lib
     , a.lib_version
     , a.project_id
     , a.activity_link
     , a.pay_link
     , a.activity_id
     , a.parent_group_id
     , b.current_language2 as reg_language
     , a.ad_group_id
     , a.ad_strategy_id
     , a.main_strategy_id
     , a.module_channel_id
     , a.recharge_index
     , a.zffs_list
     , a.is_subscription
     , a.zffs_id_list
     , a.zffs_strategy_id
     , a.etl_tm
  from ods_log.ods_sensors_cd_video_production_rechargeexposure as a
  left join dim.dim_user_account_info_view                      as b
    on a.app_product_id = b.product_id
   and a.identity_user_id = b.id
 where a.project_id = 5
;