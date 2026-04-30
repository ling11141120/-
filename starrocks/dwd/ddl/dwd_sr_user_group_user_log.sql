create table if not exists dwd.dwd_sr_user_group_user_log (
     product_id int        not null comment "产品id"
    ,group_id   int        not null comment "人群包id"
    ,user_id    bigint     not null comment "用户id"
    ,start_time datetime   not null comment "入包时间"
    ,end_time   datetime            comment "出包时间"
    ,etl_tm     datetime            comment "处理时间"
)
primary key(product_id, group_id, user_id, start_time)
comment "海阅-人群包出入包归因记录"
partition by range(start_time)
(partition p202604 values less than ("2026-05-01 00:00:00"))
distributed by hash(product_id, group_id, user_id) buckets 10
properties (
    "replication_num" = "2",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "Month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-24",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "910",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;