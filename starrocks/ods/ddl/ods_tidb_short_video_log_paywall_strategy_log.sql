drop table if exists ods.ods_tidb_short_video_log_paywall_strategy_log;
create table ods.ods_tidb_short_video_log_paywall_strategy_log (
     dt          date     not null comment "分区日期"
    ,id          bigint   not null comment "唯一ID"
    ,account_id  int               comment '用户账户ID'
    ,node_id     string            comment '节点ID'
    ,create_time datetime          comment '创建时间'
)
primary key (dt, id)
comment "海剧付费墙策略节点日志"
partition by date_trunc('day', dt)
distributed by hash (dt, id)
properties (
    "replication_num"      = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4",
    "partition_live_number" = "733"
)