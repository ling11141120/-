create or replace view ads.ads_sensors_cd_video_adrequest_view (
     dt                   comment '分区日期'
    ,id                   comment 'nvl(rid,track_id)'
    ,track_id             comment '唯一追踪ID'
    ,rid                  comment '记录ID'
    ,event_tm             comment '事件时间'
    ,device_id            comment '设备id'
    ,login_id             comment 'login_id'
    ,identity_login_id    comment 'identity_login_id'
    ,event                comment '事件'
    ,app_core_ver         comment 'core'
    ,distinct_id          comment 'distinct_id'
    ,app_product_id       comment '包体ID'
    ,lib_version          comment 'lib_version'
    ,app_version          comment 'app_version'
    ,os                   comment '操作系统'
    ,app_id               comment 'app_id'
    ,ad_position_id1      comment '广告位置ID1'
    ,failure_reason       comment '失败原因'
    ,group_id             comment '用户分组ID'
    ,request_duration     comment '请求时长'
    ,request_result       comment '请求结果'
    ,request_type1        comment '请求类型'
    ,ip                   comment 'IP'
    ,etl_tm               comment '清洗时间'
    ,page_id              comment '页面ID'
    ,page_name            comment '页面名称'
    ,element_id           comment '控件ID'
    ,element_name         comment '控件名称'
    ,element_type         comment '控件类型'
    ,ad_id                comment '广告ID'
    ,ad_platform          comment '广告平台'
    ,ad_source            comment '广告来源'
    ,ad_type              comment '广告类型'
    ,main_strategy_id     comment '主策略ID'
    ,event_strategy_id    comment '策略ID'
)
comment '海剧广告请求事件视图'
as
select  dt
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
       ,ad_position_id1
       ,failure_reason
       ,group_id
       ,request_duration
       ,request_result
       ,request_type1
       ,ip
       ,etl_tm
       ,page_id
       ,page_name
       ,element_id
       ,element_name
       ,element_type
       ,ad_id
       ,ad_platform
       ,ad_source
       ,ad_type
       ,main_strategy_id
       ,event_strategy_id
  from ods_log.ods_sensors_cd_video_adrequest
;