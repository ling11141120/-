--------------------------------------------------------------------------------
-- 目标表： ads.ads_short_video_push_delivery_view
-- 来源表： ods_log.ods_sensors_cd_video_pushdelivery
-- 开发人： qhr
-- 开发日期： 2025-10-21
-- 描述： 短视频推送送达视图
--------------------------------------------------------------------------------
create or replace view ads.ads_short_video_push_delivery_view (
     dt                   comment "分区日期"
    ,id                   comment "nvl(rid,track_id)"
    ,track_id             comment "track_id"
    ,rid                  comment "记录ID"
    ,event_tm             comment "事件时间"
    ,device_id            comment "设备id"
    ,login_id             comment "login_id"
    ,identity_login_id    comment "identity_login_id"
    ,event                comment "事件"
    ,app_core_ver         comment "core"
    ,distinct_id          comment "distinct_id"
    ,app_product_id       comment "包体ID"
    ,lib_version          comment "lib_version"
    ,app_version          comment "app_version"
    ,os                   comment "操作系统"
    ,app_id               comment "app_id"
    ,push_content         comment "推送内容"
    ,push_id              comment "推送ID"
    ,push_jump_page       comment "推送发送结果"
    ,push_send_result     comment "推送发送结果"
    ,push_title           comment "推送标题"
    ,push_type            comment "推送消息类型"
    ,project_id           comment "5阅读 8 短剧"
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
      ,event
      ,app_core_ver
      ,distinct_id
      ,app_product_id
      ,lib_version
      ,app_version
      ,os
      ,app_id
      ,push_content
      ,push_id
      ,push_jump_page
      ,push_send_result
      ,push_title
      ,push_type
      ,project_id
      ,etl_tm
  from ods_log.ods_sensors_cd_video_pushdelivery
;