----------------------------------------------------------------
-- 目标表： ods_tidb_short_video_third_payment_config
-- 来源实例： idc-tidb
-- 来源表： short_video.third_payment_config
-- 采集工具： 极光-定时批量
-- 开发人： xjc
-- 开发日期： 2025-10-10
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_short_video_third_payment_config;
CREATE TABLE ods.ods_tidb_short_video_third_payment_config (
     id                   bigint           not null                     comment "id"
    ,group_ids            varchar(3000)                                 comment "选中人群包"
    ,exclude_group_ids    varchar(3000)                                 comment "排除人群包"
    ,core                 int                                           comment "core"
    ,status               int              not null                     comment "三方支付状态总开关0关1开"
    ,update_time          datetime                                      comment "更新时间"
    ,sr_createtime        datetime         default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime        datetime         default current_timestamp    comment "starrocks数据更新时间"
)
PRIMARY KEY (id)
COMMENT "三方支付全局配置表"
DISTRIBUTED BY HASH (id)
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
