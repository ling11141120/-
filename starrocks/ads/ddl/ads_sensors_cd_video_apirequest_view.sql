create or replace view ads.ads_sensors_cd_video_apirequest_view (
     dt                   comment "分区日期"
    ,id                   comment "nvl(rid,track_id)"
    ,track_id             comment "唯一追踪ID"
    ,rid                  comment "记录ID"
    ,event_tm             comment "事件时间"
    ,device_id            comment "设备id"
    ,login_id             comment "登录id"
    ,identity_login_id    comment "身份登录ID"
    ,event                comment "事件"
    ,app_core_ver         comment "core"
    ,distinct_id          comment "distinct_id"
    ,app_product_id       comment "包体ID"
    ,lib_version          comment "lib版本"
    ,app_version          comment "app版本"
    ,os                   comment "操作系统"
    ,app_id               comment "app_id"
    ,failure_reason       comment "失败原因"
    ,request_duration     comment "请求时长"
    ,request_type1        comment "请求类型"
    ,request_result       comment "请求结果"
    ,ip                   comment "IP"
    ,anonymous_id         comment "匿名ID"
    ,etl_tm               comment "清洗时间"
)
comment "event=apiRequest API请求事件"
as
select a1.dt                   as  dt                   -- 分区日期
      ,a1.id                   as  id                   -- nvl(rid,track_id)
      ,a1.track_id             as  track_id             -- 唯一追踪ID
      ,a1.rid                  as  rid                  -- 记录ID
      ,a1.event_tm             as  event_tm             -- 事件时间
      ,a1.device_id            as  device_id            -- 设备ID
      ,a1.login_id             as  login_id             -- 登录ID
      ,a1.identity_login_id    as  identity_login_id    -- 身份登录ID
      ,a1.event                as  event                -- 事件
      ,a1.app_core_ver         as  app_core_ver         -- core
      ,a1.distinct_id          as  distinct_id          -- distinct_id
      ,a1.app_product_id       as  app_product_id       -- 包体ID
      ,a1.lib_version          as  lib_version          -- lib版本
      ,a1.app_version          as  app_version          -- app版本
      ,a1.os                   as  os                   -- 操作系统
      ,a1.app_id               as  app_id               -- app_id
      ,a1.failure_reason       as  failure_reason       -- 失败原因
      ,a1.request_duration     as  request_duration     -- 请求时长
      ,a1.request_type1        as  request_type1        -- 请求类型
      ,a1.request_result       as  request_result       -- 请求结果
      ,a1.ip                   as  ip                   -- IP
      ,a1.anonymous_id         as  anonymous_id         -- 匿名ID
      ,a1.etl_tm               as  etl_tm               -- 清洗时间
  from ods_log.ods_sensors_cd_video_apirequest    as a1
;