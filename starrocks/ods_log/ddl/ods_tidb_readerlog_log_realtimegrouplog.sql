----------------------------------------------------------------
-- 目标表： ods_log.ods_tidb_readerlog_log_realtimegrouplog（2026-4-24：暂停采集）
-- 来源实例： old_tidb_source
-- 来源表：readerlog_en.Log_RealTimeGroupLog
-- 来源负责： 串总
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2026-04-29
----------------------------------------------------------------

create table if not exists ods_log.ods_tidb_readerlog_log_realtimegrouplog (
     dt            date         not null                  comment "createtime 分区"
    ,Id            bigint       not null                  comment ""
    ,ProductId     int          not null                  comment "ProductId"
    ,UserId        bigint                                 comment "userid"
    ,GroupId       int                                    comment "GroupId"
    ,OpType        int                                    comment "操作类型 0:入包 3:出包"
    ,StartTime     datetime                               comment "开始时间"
    ,EndTime       datetime                               comment "结束时间"
    ,CreateTime    datetime                               comment "创建时间（入包时间-东八区） createtime来当作入包时间"
    ,AppId         int                                    comment "AppId"
    ,ParentGroupId int                                    comment "父人群包Id"
    ,GroupType     int                                    comment "0父 1子"
    ,HashId        bigint                                 comment "HashId"
    ,GroupsDetail  varchar(500)                           comment "取模明细"
    ,sr_createtime datetime     default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime     default current_timestamp comment "starrocks数据更新时间"
    ,index index1 (GroupId) using bitmap                  comment 'index_productid'
)
primary key(dt, Id, ProductId)
comment "人群包用户实时数据"
partition by range(dt)
(partition p20260429 values less than ("2026-04-30"))
distributed by hash(Id, ProductId) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "UserId, CreateTime",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-732",
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