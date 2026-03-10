drop table if exists dwm.dwm_ab_exp_user_accumulation_stat_di;
create table dwm.dwm_ab_exp_user_accumulation_stat_di (
     dt               date           not null comment "日期天分区"
    ,exp_id           int            not null comment "实验ID"
    ,exp_grp_id       int            not null comment "实验组ID"
    ,exp_grp_ver_id   bigint         not null comment "实验组版本ID"
    ,user_id          bigint         not null comment "用户ID"
    ,recharge_amount  decimal(20, 2)          comment "用户充值收入"
    ,total_adv_amount decimal(20, 2)          comment "总广告收入"
    ,adv_amount       decimal(20, 2)          comment "广告收入"
    ,third_h5_amount  decimal(20, 2)          comment "三方H5收入"
    ,adv_unlock_times bigint                  comment "广告解锁剧集次数"
    ,unlock_amount    bigint                  comment "解锁数量"
    ,etl_time         datetime       not null comment "数据清洗时间"
    ,watch_episodes   bigint                  comment "观看集数"
)
primary key(dt, exp_id, exp_grp_id, exp_grp_ver_id, user_id)
comment "海剧-AB实验-用户明细中间表"
partition by range(dt)
(partition p20260303 values less than ("2026-03-04"))
distributed by hash(exp_id, exp_grp_id, exp_grp_ver_id, user_id) buckets 3
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "exp_id, user_id, exp_grp_id, exp_grp_ver_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-365",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;