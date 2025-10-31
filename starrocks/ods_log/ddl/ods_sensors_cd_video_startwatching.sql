----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_startwatching
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具： 极光-实时映射
-- 开发人： wx
-- 开发日期： 2025-10-31
----------------------------------------------------------------
drop table if exists ods_log.ods_sensors_cd_video_startwatching;
create table ods_log.ods_sensors_cd_video_startwatching (
     dt                          date              NOT NULL COMMENT "日期"
    ,id                          varchar(65533)    NOT NULL COMMENT "主键"
    ,rid                         varchar(65533)             COMMENT "记录ID"
    ,track_id                    varchar(65533)             COMMENT "track_id"
    ,event                       varchar(65533)             COMMENT "事件"
    ,event_tm                    datetime                   COMMENT "事件时间"
    ,app_channel                 varchar(65533)             COMMENT "渠道编号"
    ,app_id                      varchar(65533)             COMMENT "app_id"
    ,app_lang_id                 varchar(65533)             COMMENT "界面语言"
    ,device_lang                 varchar(65533)             COMMENT "设备语言"
    ,login_id                    varchar(65533)             COMMENT "用户ID"
    ,product_id                  varchar(65533)             COMMENT "产品ID"
    ,app_version                 varchar(65533)             COMMENT "应用版本"
    ,os                          varchar(65533)             COMMENT "操作系统"
    ,ip                          varchar(65533)             COMMENT "IP"
    ,city                        varchar(65533)             COMMENT "城市"
    ,province                    varchar(65533)             COMMENT "省份"
    ,country                     varchar(65533)             COMMENT "国家"
    ,shortplay_id                varchar(65533)             COMMENT "短剧ID"
    ,if_first_watch_shortplay    varchar(65533)             COMMENT "短剧是否首次观看"
    ,episode_id                  varchar(65533)             COMMENT "剧集ID"
    ,watch_episode_sort          varchar(65533)             COMMENT "内容页剧集ID序号"
    ,watch_source_id             varchar(65533)             COMMENT "观看来源控件id"
    ,watch_source_name           varchar(65533)             COMMENT "观看来源控件名称"
    ,watch_source_page_id        varchar(65533)             COMMENT "观看来源页面id"
    ,watch_source_page_name      varchar(65533)             COMMENT "观看来源页面名称"
    ,watch_speeds                varchar(65533)             COMMENT "观看倍速"
    ,send_id                     varchar(65533)             COMMENT "发送ID"
    ,activity_link               varchar(65533)             COMMENT "活动链路"
    ,etl_tm                      datetime                   COMMENT "清洗时间"
)
PRIMARY KEY(dt, id)
COMMENT "event=startWatching 开始观看"
PARTITION BY RANGE(dt)
DISTRIBUTED BY HASH(dt, id) BUCKETS 1
PROPERTIES (
    "replication_num" = "2",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-92",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;