create view ads_sensors_production_H5BackToApp_view(
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
      ,app_core_ver
      ,app_channel
      ,app_product_x
      ,app_lang_id
      ,lib_version
      ,app_version
      ,ad_position_id
      ,project_id
      ,app_id
      ,product_id
      ,os
      ,ip
      ,city
      ,app_name
      ,status
      ,task_id
      ,ad_strategy_id
      ,ad_group_id
      ,event_strategy_id
      ,main_strategy_id
      ,programme_id
      ,module_channel_id
      ,etl_tm
  from ods_log.ods_sensors_production_H5BackToApp
;