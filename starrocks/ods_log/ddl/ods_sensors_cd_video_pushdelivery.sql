----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_pushdelivery
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 极光-实时映射
-- 开发人： qhr
-- 开发日期： 2025-10-21
----------------------------------------------------------------

DROP TABLE IF EXISTS ods_log.ods_sensors_cd_video_pushdelivery;
CREATE TABLE ods_log.ods_sensors_cd_video_pushdelivery (
     dt                DATE         NOT NULL COMMENT "分区日期"
    ,id                STRING       NOT NULL COMMENT "nvl(rid,track_id)"
    ,track_id          STRING                COMMENT ""
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
    ,push_content      STRING                COMMENT "推送内容"
    ,push_id           STRING                COMMENT "推送ID"
    ,push_jump_page    STRING                COMMENT "推送发送结果"
    ,push_send_result  STRING                COMMENT "推送发送结果"
    ,push_title        STRING                COMMENT "推送标题"
    ,push_type         STRING                COMMENT "推送消息类型"
    ,project_id        STRING                COMMENT "5阅读 8 短剧"
    ,etl_tm            DATETIME              COMMENT "清洗时间"

)
PRIMARY KEY(dt, id)
COMMENT "event=pushDelivery push送达事件"
PARTITION BY RANGE(dt)
(PARTITION p20251021 VALUES LESS THAN ("2025-10-21"))
DISTRIBUTED BY HASH(dt, id) BUCKETS 5
PROPERTIES (
    "replication_num" = "3"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "DAY"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-365"
    ,"dynamic_partition.end" = "3"
    ,"dynamic_partition.prefix" = "p"
    ,"dynamic_partition.buckets" = "3"
    ,"dynamic_partition.history_partition_num" = "0"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "ZSTD"
)
;