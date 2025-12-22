create view ads.ads_sensors_production_adpositionclick_view(
     dt                   comment "分区日期"
    ,id                   comment "nvl(rid,track_id)"
    ,track_id
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
    ,app_id               comment "app_id"
    ,app_core_ver         comment "core"
    ,lib                  comment "平台"
    ,app_channel          comment "渠道编号"
    ,app_product_x        comment "应用程序ID"
    ,app_lang_id          comment "界面语言"
    ,lib_version          comment "lib_version"
    ,app_version          comment "app_version"
    ,page_id              comment "页面ID"
    ,page_name            comment "页面名称"
    ,ad_type              comment "广告类型"
    ,ad_position_id       comment "广告位ID"
    ,ad_position_id1      comment "广告位ID_new"
    ,project_id           comment "5阅读 8 短剧"
    ,etl_tm               comment "清洗时间"
    ,product_id           comment "产品ID"
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
)
as
select dt
      ,id
      ,track_id
      ,rid
      ,event_tm
      ,device_id
      ,login_id
      ,identity_login_id
      ,device_lang
      ,event
      ,distinct_id
      ,identity_user_id
      ,app_product_id
      ,send_id
      ,app_id
      ,app_core_ver
      ,lib
      ,app_channel
      ,app_product_x
      ,app_lang_id
      ,lib_version
      ,app_version
      ,page_id
      ,page_name
      ,ad_type
      ,ad_position_id
      ,ad_position_id1
      ,project_id
      ,etl_tm
      ,product_id
      ,os
      ,ip
      ,city
      ,element_id
      ,element_name
      ,element_type
      ,event_strategy_id
      ,parent_group_id
      ,main_strategy_id
      ,ad_strategy_id
      ,ad_group_id
      ,programme_id
      ,module_channel_id
  from ods_log.ods_sensors_production_adpositionclick
;