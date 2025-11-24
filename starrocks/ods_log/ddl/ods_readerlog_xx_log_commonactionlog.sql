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
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-11-23
----------------------------------------------------------------

drop table if exists ods_log.ods_readerlog_xx_log_commonactionlog;
create table ods_log.ods_readerlog_xx_log_commonactionlog (
     dt            date            not null                  comment ""
    ,productid     int(11)         not null                  comment ""
    ,Id            bigint(20)      not null                  comment ""
    ,UserId        bigint(20)                                comment ""
    ,Action        varchar(1512)                             comment ""
    ,ProdId        varchar(1512)                             comment ""
    ,Chl           varchar(1512)                             comment ""
    ,IMEI          varchar(1512)                             comment ""
    ,mt            int(11)                                   comment ""
    ,appver        varchar(1512)                             comment ""
    ,smallpt       varchar(1512)                             comment ""
    ,F0            bigint(20)                                comment ""
    ,F1            bigint(20)                                comment ""
    ,F2            bigint(20)                                comment ""
    ,F3            bigint(20)                                comment ""
    ,F4            bigint(20)                                comment ""
    ,F5            bigint(20)                                comment ""
    ,F6            bigint(20)                                comment ""
    ,F7            bigint(20)                                comment ""
    ,F8            bigint(20)                                comment ""
    ,F9            bigint(20)                                comment ""
    ,S0            varchar(65533)                            comment ""
    ,S1            varchar(65533)                            comment ""
    ,S2            varchar(65533)                            comment ""
    ,S3            varchar(65533)                            comment ""
    ,S4            varchar(65533)                            comment ""
    ,S5            varchar(65533)                            comment ""
    ,S6            varchar(65533)                            comment ""
    ,S7            varchar(65533)                            comment ""
    ,S8            varchar(65533)                            comment ""
    ,S9            varchar(65533)                            comment ""
    ,CreateTime    datetime                                  comment ""
    ,AppId         int(11)                                   comment ""
    ,sr_createtime datetime        default current_timestamp comment ""
    ,sr_updatetime datetime                                  comment ""
)
primary key (dt, productid, Id)
partition by range (dt)
distributed by hash (Id) buckets 1
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-3650",
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