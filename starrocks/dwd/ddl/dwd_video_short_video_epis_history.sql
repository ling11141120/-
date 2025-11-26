drop table if exists dwd.dwd_video_short_video_epis_history;
create table dwd.dwd_video_short_video_epis_history (
     dt           date         not null                  comment "日期，根据CreateTime转换而来"
    ,id           bigint(20)   not null                  comment "历史记录主键id"
    ,account_id   bigint(20)   not null                  comment "用户id"
    ,series_id    bigint(20)   not null                  comment "剧id"
    ,epis_id      bigint(20)   not null                  comment "集id"
    ,watch_stamp  int(11)      not null                  comment "观看时间戳"
    ,create_time  datetime     not null                  comment "创建时间"
    ,epis_num     int(11)                                comment "集数"
    ,region_id    smallint(6)                            comment "归属区域 id，1：香港，2：北美；"
    ,watch_over   tinyint(4)                             comment "是否观看完成"
    ,etl_time     datetime     default current_timestamp comment "sr数据创建时间"
)
primary key(dt, id)
comment "短剧域海外短剧有效观看记录表"
partition by range(dt)
(partition p202510 values less than ("2025-11-01"))
distributed by hash(id) buckets 3
properties (
    "replication_num" = "2",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "15",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;