create or replace view ads.ads_sensors_cd_video_adinvocation_view (
     dt                   comment "分区日期"
    ,id                   comment "nvl(rid,track_id)"
    ,track_id             comment "track_id"
    ,rid                  comment "记录id"
    ,event_tm             comment "事件时间"
    ,device_id            comment "设备id"
    ,login_id             comment "login_id"
    ,identity_login_id    comment "identity_login_id"
    ,device_lang          comment "设备语言"
    ,event                comment "事件"
    ,distinct_id          comment "distinct_id"
    ,app_product_id       comment "包体id"
    ,app_core_ver         comment "core"
    ,app_product_x        comment "应用程序id"
    ,app_channel          comment "渠道编号"
    ,app_lang_id          comment "界面语言"
    ,lib_version          comment "lib_version"
    ,app_version          comment "app_version"
    ,page_id              comment "页面ID"
    ,page_name            comment "页面名称(1)"
    ,ad_position_id1      comment "广告位ID"
    ,element_id           comment "控件ID"
    ,element_name         comment "控件名称"
    ,element_type         comment "控件类型"
    ,ad_id                comment "广告ID"
    ,ad_platform          comment "广告平台"
    ,ad_source            comment "广告来源"
    ,ad_type              comment "广告类型"
    ,main_strategy_id     comment "主策略ID"
    ,event_strategy_id    comment "策略ID"
    ,project_id           comment "项目id：5阅读 8短剧"
    ,os                   comment "操作系统"
    ,app_id               comment "app_id"
)
comment "海剧广告调用"
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
      ,app_product_id
      ,app_core_ver
      ,app_product_x
      ,app_channel
      ,app_lang_id
      ,lib_version
      ,app_version
      ,page_id
      ,page_name
      ,ad_position_id1
      ,element_id
      ,element_name
      ,element_type
      ,ad_id
      ,ad_platform
      ,ad_source
      ,ad_type
      ,main_strategy_id
      ,event_strategy_id
      ,project_id
      ,os
      ,app_id
  from ods_log.ods_sensors_production_adinvocation
 where project_id = 8
;