create or replace view ads.ads_sensors_video_pushclick_view (
    dt                    COMMENT "分区日期"
   ,id                    COMMENT "nvl(rid,track_id)"
   ,track_id
   ,rid                   COMMENT "记录ID"
   ,event_tm              COMMENT "事件时间"
   ,device_id             COMMENT "设备id"
   ,login_id              COMMENT "login_id"
   ,identity_login_id     COMMENT "identity_login_id"
   ,device_lang           COMMENT "设备语言"
   ,event                 COMMENT "事件"
   ,distinct_id           COMMENT "distinct_id"
   ,identity_user_id      COMMENT "identity_userid"
   ,app_product_id        COMMENT "包体ID"
   ,send_id               COMMENT "转化来源"
   ,app_core_ver          COMMENT "core"
   ,app_channel           COMMENT "渠道编号"
   ,app_product_x         COMMENT "应用程序ID"
   ,app_lang_id           COMMENT "界面语言"
   ,lib_version           COMMENT "lib_version"
   ,app_version           COMMENT "app_version"
   ,push_id               COMMENT "pushID"
   ,push_title_id         COMMENT "推送标题ID"
   ,push_content_id       COMMENT "推送内容ID"
   ,push_title            COMMENT "推送标题"
   ,content_name          COMMENT "内容名称"
   ,jump_type             COMMENT "跳转类型"
   ,push_type             COMMENT "消息类型"
   ,project_id            COMMENT "5阅读 8 短剧"
   ,os                    COMMENT "操作系统"
   ,app_id                COMMENT "app_id"
   ,etl_tm                COMMENT "清洗时间"
)
comment "video pushclick view"
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
      ,push_id
      ,push_title_id
      ,push_content_id
      ,push_title
      ,content_name
      ,jump_type
      ,push_type
      ,project_id
      ,os
      ,app_id
      ,etl_tm
  from ods_log.ods_sensors_production_pushclick
 where project_id = 8
;