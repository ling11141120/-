create table if not exists ads.ads_sr_beidou_group_crowd_log (
     dt         date        not null       comment "分区，日期格式"
    ,Id         bigint      not null       comment "主键"
    ,CreateTime datetime    not null       comment "日志时间"
    ,CrowdId    int                        comment "人群包id"
    ,UserId     bigint                     comment "用户id"
    ,SubCrowdId int                        comment "子人群包id"
    ,Operation  int                        comment "操作 1：入包 2：出包 3：跳包 4：调试"
    ,BeginTime  datetime                   comment "人群包入包时间"
    ,EndTime    datetime                   comment "人群包出包时间"
    ,Remark     string                     comment "出入包说明"
    ,ProductId  varchar(10) default "6833" comment "产品id"
    ,ProjectId  int         default "3"    comment "项目id:1海阅；2国内短剧；3海外短剧"
)
primary key(dt, id, createtime)
comment "人群包出入包日志表"
partition by range(dt)
(partition p20260608 values less than ("2026-06-09"))
distributed by hash(id) buckets 40
properties (
    "replication_num" = "2",
    "bloom_filter_columns" = "CrowdId, UserId",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-180",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
