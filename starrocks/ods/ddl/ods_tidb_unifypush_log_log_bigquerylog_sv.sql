----------------------------------------------------------------
-- 目标表： ods.ods_tidb_unifypush_log_log_bigquerylog_sv
-- 来源实例： old_tidb_source
-- 来源表： unifypush_log.log_bigquerylog_sv
-- 来源负责：施维串
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2025-12-31
----------------------------------------------------------------

drop table if exists ods.ods_tidb_unifypush_log_log_bigquerylog_sv;
create table ods.ods_tidb_unifypush_log_log_bigquerylog_sv (
    dt               date          not null                     comment "日期"
   ,id               bigint(20)    not null                     comment "主键id"
   ,prodid           int(11)       not null                     comment "产品id，即为core"
   ,eventtime        datetime                                   comment "事件时间"
   ,messageid        varchar(765)                               comment "消息id用于标识消息。消息 id 根据应用 id 和时间戳生成，在某些情况下可能不是全局唯一的。"
   ,instanceid       varchar(765)                               comment "消息发送到的应用的唯一 id,如有,它可以是实例 id 或 firebase 安装 id。"
   ,messagetype      varchar(765)                               comment "消息的类型。可以是通知消息或数据消息。主题用于标识主题或广告系列发送的原始消息；后续消息则为通知消息或数据消息。"
   ,eventtype        varchar(765)                               comment "事件类型"
   ,createtime       datetime      not null                     comment "数据创建时间"
   ,partitiontime    datetime      not null                     comment "分区时间"
   ,sr_createtime    datetime      default current_timestamp    comment "starrocks数据注入时间"
   ,sr_updatetime    datetime      default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt, id, prodid)
comment "推送消息到达状态记录表 author:915386"
partition by range(dt)
distributed by hash(dt, id)
properties (
    "replication_num" = "3"
   ,"dynamic_partition.enable" = "true"
   ,"dynamic_partition.time_unit" = "day"
   ,"dynamic_partition.time_zone" = "Asia/Shanghai"
   ,"dynamic_partition.start" = "-45"
   ,"dynamic_partition.end" = "3"
   ,"dynamic_partition.prefix" = "p"
   ,"dynamic_partition.history_partition_num" = "0"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;