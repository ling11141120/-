----------------------------------------------------------------
-- 目标表： ods_log.ods_tidb_readerlog_Log_BigQueryLog
-- 来源实例： old_tidb_source
-- 来源表：
--         readerlog_en.Log_BigQueryLog
--         readerlog_fr.Log_BigQueryLog
--         readerlog_ft.Log_BigQueryLog
--         readerlog_id.Log_BigQueryLog
--         readerlog_jp.Log_BigQueryLog
--         readerlog_pt.Log_BigQueryLog
--         readerlog_ru.Log_BigQueryLog
--         readerlog_sp.Log_BigQueryLog
--         readerlog_th.Log_BigQueryLog
-- 来源负责： 串总
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2026-01-06
----------------------------------------------------------------

drop table if exists ods_log.ods_tidb_readerlog_Log_BigQueryLog;
create table ods_log.ods_tidb_readerlog_Log_BigQueryLog (
     dt            date     not null                  comment "createtime 分区"
    ,product_id    int      not null                  comment "产品id"
    ,Id            bigint   not null                  comment "自增id"
    ,ProdId        int                                comment "x值，早期用来区别app的"
    ,EventTime     datetime                           comment "事件时间"
    ,MessageId     string                             comment "消息id"
    ,InstanceId    string                             comment "实例id"
    ,EventType     string                             comment "事件类型"
    ,AppId         int                                comment "应用程序id"
    ,CreateTime    datetime                           comment "创建时间"
    ,sr_createtime datetime default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime default current_timestamp comment "starrocks数据更新时间"
    ,index index_productid (product_id) using bitmap  comment 'index_productid'
)
primary key(dt, product_id, Id)
comment "push推送 送达相关日志表"
partition by range(dt)
(partition p20260106 values less than ("2026-01-07"))
distributed by hash(dt, product_id, Id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "CreateTime",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;