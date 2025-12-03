----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_log_log_attributioncommonlog
-- 来源实例： old_tidb_source
-- 来源表： hallow_log.log_attributioncommonlog
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-12-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_log_log_attributioncommonlog;
create table ods.ods_tidb_hallow_log_log_attributioncommonlog (
     dt            date          not null comment "分区日期"
    ,Id            bigint        not null comment 'Id'
    ,Action        varchar(1536)          comment '来源的action'
    ,MT            int                    comment 'mt'
    ,Core          int                    comment 'Core'
    ,UserId        bigint                 comment '用户Id'
    ,CreateTime    datetime      not null comment '创建时间'
    ,F0            bigint                 comment 'F0'
    ,F1            bigint                 comment 'F1'
    ,F2            bigint                 comment 'F2'
    ,F3            bigint                 comment 'F3'
    ,F4            bigint                 comment 'F4'
    ,F5            bigint                 comment 'F5'
    ,F6            bigint                 comment 'F6'
    ,F7            bigint                 comment 'F7'
    ,F8            bigint                 comment 'F8'
    ,F9            bigint                 comment 'F9'
    ,S0            string                 comment 'S0'
    ,S1            string                 comment 'S1'
    ,S2            string                 comment 'S2'
    ,S3            string                 comment 'S3'
    ,S4            string                 comment 'S4'
    ,S5            string                 comment 'S5'
    ,S6            string                 comment 'S6'
    ,S7            string                 comment 'S7'
    ,S8            string                 comment 'S8'
    ,S9            string                 comment 'S9'
    ,sr_createtime datetime               comment "starrocks入库时间"
    ,sr_updatetime datetime               comment "starrocks数据更新时间"
)
duplicate key(dt, Id)
comment "广告归因通用日志表"
partition by date_trunc("month", dt)
distributed by hash(dt, Id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
