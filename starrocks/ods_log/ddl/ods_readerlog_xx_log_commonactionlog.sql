----------------------------------------------------------------
-- 目标表： ods_log.ods_readerlog_xx_log_commonactionlog
-- 来源实例： old_tidb_source
-- 来源表：
--       readerlog_fr.Log_CommonActionLog
--       readerlog_pt.Log_CommonActionLog
--       readerlog_ft.Log_CommonActionLog
--       readerlog_en.Log_CommonActionLog
--       readerlog_ru.Log_CommonActionLog
--       readerlog_sp.Log_CommonActionLog
--       readerlog_jp.Log_CommonActionLog
--       readerlog_id.Log_CommonActionLog
--       readerlog_th.Log_CommonActionLog
--       readerlog_and2_sync.Log_CommonActionLog
--       readerlog_cd2_sync.Log_CommonActionLog
--       readerlog_cd.Log_CommonActionLog
--       readerlog_and.Log_CommonActionLog
-- 来源负责：
-- 开发人： 050239
-- 开发日期： 2025-11-23
----------------------------------------------------------------

create table if not exists ods_log.ods_readerlog_xx_log_commonactionlog (
     dt            date          not null                  comment ""
    ,productid     int           not null                  comment ""
    ,Id            bigint        not null                  comment ""
    ,UserId        bigint                                  comment ""
    ,Action        varchar(1512)                           comment ""
    ,ProdId        varchar(1512)                           comment ""
    ,Chl           varchar(1512)                           comment ""
    ,IMEI          varchar(1512)                           comment ""
    ,mt            int                                     comment ""
    ,appver        varchar(1512)                           comment ""
    ,smallpt       varchar(1512)                           comment ""
    ,F0            bigint                                  comment ""
    ,F1            bigint                                  comment ""
    ,F2            bigint                                  comment ""
    ,F3            bigint                                  comment ""
    ,F4            bigint                                  comment ""
    ,F5            bigint                                  comment ""
    ,F6            bigint                                  comment ""
    ,F7            bigint                                  comment ""
    ,F8            bigint                                  comment ""
    ,F9            bigint                                  comment ""
    ,S0            string                                  comment ""
    ,S1            string                                  comment ""
    ,S2            string                                  comment ""
    ,S3            string                                  comment ""
    ,S4            string                                  comment ""
    ,S5            string                                  comment ""
    ,S6            string                                  comment ""
    ,S7            string                                  comment ""
    ,S8            string                                  comment ""
    ,S9            string                                  comment ""
    ,CreateTime    datetime                                comment ""
    ,AppId         int                                     comment ""
    ,sr_createtime datetime      default current_timestamp comment ""
    ,sr_updatetime datetime                                comment ""
)
primary key(dt, productid, id)
partition by range(dt)
(partition p20260515 values less than ("2026-05-16"))
distributed by hash(id) buckets 1
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-733",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "10",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
