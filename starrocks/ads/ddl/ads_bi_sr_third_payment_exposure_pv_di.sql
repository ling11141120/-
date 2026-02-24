drop table if exists ads.ads_bi_sr_third_payment_exposure_pv_di;
create table ads.ads_bi_sr_third_payment_exposure_pv_di (
     dt                date         not null comment "日期分区"
    ,element_id        varchar(300) not null comment "控件ID"
    ,event_strategy_id varchar(300) not null comment "策略id"
    ,core              int          not null comment "corever"
    ,mt                int          not null comment "mt"
    ,user_id           bigint       not null comment "用户id"
    ,programme_id      varchar(300) not null comment "方案id"
    ,recharge_type     varchar(300) not null comment "充值类型"
    ,zffs_id_list      string                comment "支付方式ID列表"
    ,payment           string                comment "支付方式"
    ,payment_way       string                comment "支付渠道"
    ,exposure_pv       int                   comment "曝光pv（重复操作去重）"
    ,exposure_pv2      int                   comment "曝光pv（不去重）"
    ,etl_time          datetime     not null comment "数据清洗时间"
)
primary key(dt, element_id, event_strategy_id, core, mt, user_id, programme_id, recharge_type)
comment "海阅三方支付漏斗报表——曝光数据"
partition by range(dt)
(partition p20260224 values less than ("2025-12-25"))
distributed by hash(element_id, event_strategy_id, user_id) buckets 7
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "user_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-92",
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