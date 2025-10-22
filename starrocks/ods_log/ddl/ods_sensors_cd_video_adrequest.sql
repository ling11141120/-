----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_adrequest
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 极光-实时映射
-- 开发人： qhr
-- 开发日期： 2025-10-22
----------------------------------------------------------------

DROP TABLE IF EXISTS ods_log.ods_sensors_cd_video_adrequest;
CREATE TABLE ods_log.ods_sensors_cd_video_adrequest (
     dt                DATE         NOT NULL COMMENT "分区日期"
    ,id                STRING       NOT NULL COMMENT "nvl(rid,track_id)"
    ,track_id          STRING                COMMENT "唯一追踪ID"
    ,rid               STRING                COMMENT "记录ID"
    ,event_tm          DATETIME              COMMENT "事件时间"
    ,device_id         STRING                COMMENT "设备id"
    ,login_id          STRING                COMMENT "login_id"
    ,identity_login_id STRING                COMMENT "identity_login_id"
    ,event             STRING                COMMENT "事件"
    ,app_core_ver      STRING                COMMENT "core"
    ,distinct_id       STRING                COMMENT "distinct_id"
    ,app_product_id    STRING                COMMENT "包体ID"
    ,lib_version       STRING                COMMENT "lib_version"
    ,app_version       STRING                COMMENT "app_version"
    ,os                VARCHAR(200)          COMMENT "操作系统"
    ,app_id            STRING                COMMENT "app_id"
    ,ad_position_id1   STRING                COMMENT "广告位置ID1"
    ,failure_reason    STRING                COMMENT "失败原因"
    ,group_id          STRING                COMMENT "用户分组ID"
    ,request_duration  DECIMAL(5,3)          COMMENT "请求时长"
    ,request_result    STRING                COMMENT "请求结果"
    ,request_type1     STRING                COMMENT "请求类型"
    ,ip                STRING                COMMENT "IP"
    ,etl_tm            DATETIME              COMMENT "清洗时间"
)
PRIMARY KEY(dt, id)
COMMENT "event=ADRequest 广告请求事件"
PARTITION BY DATE_TRUNC('day', dt)
DISTRIBUTED BY HASH(dt, id)
PROPERTIES (
    "replication_num" = "3"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "ZSTD"
)
;