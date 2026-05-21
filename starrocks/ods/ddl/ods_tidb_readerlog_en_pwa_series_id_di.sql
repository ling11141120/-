----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readerlog_en_pwa_series_id_di
-- 来源实例： old_tidb_source
-- 来源表： readerlog_en.Log_PWASeriesIdLog
-- 来源负责：
-- 采集工具：SeaTunnel
-- 开发人： tyg
-- 开发日期：2026-05-21
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readerlog_en_pwa_series_id_di;
create table ods.ods_tidb_readerlog_en_pwa_series_id_di (
     dt                   date          not null                    comment "分区"
    ,id                   bigint        not null                    comment "日志Id"
    ,user_id              bigint        null                        comment "用户Id"
    ,series_id            bigint        null                        comment "剧Id"
    ,create_time          datetime      null                        comment "创建时间"
    ,app_id               int           null                        comment "appid"
    ,unique_cd_reader_id  varchar(765)  null                        comment "设备Id"
    ,video_user_id        bigint        null                        comment "海剧的用户id"
    ,mt                   int           null                        comment "mt"
    ,sr_createtime        datetime      default current_timestamp   comment "starrocks入库时间"
    ,sr_updatetime        datetime      default current_timestamp   comment "starrocks数据更新时间"
)
primary key(dt,id)
comment "pwa剧Id日志"
partition by date_trunc("day", `dt`)
distributed by HASH(`id`) BUCKETS 5
properties (
     "replication_num" = "3"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "DAY"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-365"
    ,"dynamic_partition.end" = "3"
    ,"dynamic_partition.prefix" = "p"
    ,"dynamic_partition.buckets" = "5"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "false"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
);
