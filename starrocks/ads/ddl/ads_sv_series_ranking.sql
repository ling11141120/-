drop table if exists ads.ads_sv_series_ranking;
create table ads.ads_sv_series_ranking (
     dt             date           not null comment "分区日期"
    ,days           int            not null comment "榜单周期天数"
    ,series_id      bigint         not null comment "剧 ID"
    ,lang_id        int            not null comment "剧语言 ID"
    ,publish_edat   datetime                comment "剧上架时间"
    ,series_level   int                     comment "等级 1.S 2.A 3.B 4.C"
    ,publish_status int                     comment "剧上架状态 (1 上架 2 下架)"
    ,consume_value  decimal(20, 6)          comment "消费数量"
    ,uv             bigint                  comment "播放量（UV）"
    ,vip_unlock_episode_count bigint(20)    comment "VIP解锁集数"
    ,etl_time       datetime       not null comment "数据清洗时间"
)
primary key(dt, days, series_id)
comment "短剧 - 消费、热播、新剧榜"
partition by range(dt)
(partition p202603 values less than ('2026-04-01'))
distributed by hash(dt, days, series_id) buckets 3
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, days, series_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "LZ4"
)
;
