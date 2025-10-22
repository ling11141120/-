----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_production_pushclick
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 极光-实时映射
-- 开发人： qhr
-- 开发日期： 2025-10-22
----------------------------------------------------------------

DROP TABLE IF EXISTS ods_log.ods_sensors_production_pushclick;
CREATE TABLE ods_log.ods_sensors_production_pushclick (
     dt                   DATE         NOT NULL COMMENT "分区日期"
    ,id                   STRING       NOT NULL COMMENT "nvl(rid,track_id)"
    ,track_id             STRING                COMMENT ""
    ,rid                  STRING                COMMENT "记录ID"
    ,event_tm             DATETIME              COMMENT "事件时间"
    ,device_id            STRING                COMMENT "设备id"
    ,login_id             STRING                COMMENT "login_id"
    ,identity_login_id    STRING                COMMENT "identity_login_id"
    ,device_lang          STRING                COMMENT "设备语言"
    ,event                STRING                COMMENT "事件"
    ,distinct_id          STRING                COMMENT "distinct_id"
    ,identity_user_id     STRING                COMMENT "identity_userid"
    ,app_product_id       STRING                COMMENT "包体ID"
    ,send_id              STRING                COMMENT "转化来源"
    ,app_core_ver         STRING                COMMENT "core"
    ,app_channel          STRING                COMMENT "渠道编号"
    ,app_product_x        STRING                COMMENT "应用程序ID"
    ,app_lang_id          STRING                COMMENT "界面语言"
    ,lib_version          STRING                COMMENT "lib_version"
    ,app_version          STRING                COMMENT "app_version"
    ,push_id              STRING                COMMENT "pushID"
    ,push_title           STRING                COMMENT "推送标题"
    ,content_name         STRING                COMMENT "内容名称"
    ,jump_type            STRING                COMMENT "跳转类型"
    ,push_type            STRING                COMMENT "消息类型"
    ,project_id           STRING                COMMENT "5阅读 8 短剧"
    ,os                   VARCHAR(200)          COMMENT "操作系统"
    ,app_id               STRING                COMMENT "app_id"
    ,etl_tm               DATETIME              COMMENT "清洗时间"
)
PRIMARY KEY(dt, id)
COMMENT "event=pushClick 点击push并跳转进APP后上报"
PARTITION BY RANGE(dt)
(PARTITION p20251021 VALUES LESS THAN ("2025-10-22"))
DISTRIBUTED BY HASH(dt, id) BUCKETS 1
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