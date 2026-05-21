----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readerlog_en_log_pwaseriesIdlog
-- 来源实例： old_tidb_source
-- 来源表： readerlog_en.Log_PWASeriesIdLog
-- 来源负责：
-- 采集工具：SeaTunnel
-- 开发人： tyg
-- 开发日期：2026-05-21
----------------------------------------------------------------

create table if not exists ods.ods_tidb_readerlog_en_log_pwaseriesIdlog (
     dt                   date          not null                   comment "分区"
    ,id                   bigint        not null                   comment "日志Id"
    ,user_id              bigint                                   comment "用户Id"
    ,series_id            bigint                                   comment "剧Id"
    ,create_time          datetime                                 comment "创建时间"
    ,app_id               int                                      comment "appid"
    ,unique_cd_reader_id  varchar(765)                             comment "设备Id"
    ,video_user_id        bigint                                   comment "海剧的用户id"
    ,mt                   int                                      comment "mt"
    ,sr_createtime        datetime      default current_timestamp  comment "StarRocks数据注入时间"
    ,sr_updatetime        datetime      default current_timestamp  comment "Starrocks数据更新时间"
)
primary key(dt, id)
comment "pwa剧Id日志"
partition by date_trunc('day', dt)
distributed by hash(dt,id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4",
    "partition_live_number" = "365"
)
;
