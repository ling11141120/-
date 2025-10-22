create or replace view ads.ads_sensors_production_app_launch_view (
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
   ,type                 comment "类型"
   ,lib                  comment "lib"
   ,activity_link        comment "活动链路"
   ,os                   comment "操作系统"
   ,app_module           comment "模块"
   ,start_type           comment "启动方式"
   ,etl_tm               comment "清洗时间"
)
comment "app launch view"
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
      ,type
      ,lib
      ,activity_link
      ,os
      ,app_module
      ,start_type
      ,etl_tm
  from ods_log.ods_sensors_production_app_launch
;