create or replace view ads.ads_sensors_cd_video_apirequest_view (
     dt                   comment "分区日期"
    ,id                   comment "nvl(rid,track_id)"
    ,track_id             comment "唯一追踪ID"
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
    ,failure_reason       comment "失败原因"
    ,request_duration     comment "请求时长"
    ,request_type1        comment "请求类型"
    ,request_result       comment "请求结果"
    ,ip                   comment "IP"
    ,etl_tm               comment "清洗时间"
)
comment '海剧接口请求事件视图'
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
      ,failure_reason
      ,request_duration
      ,request_type1
      ,request_result
      ,ip
      ,etl_tm
  from ods_log.ods_sensors_cd_video_apirequest
;