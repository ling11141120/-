drop table if exists ads.ads_sv_third_party_payment_funnel_exposure;
create table ads.ads_sv_third_party_payment_funnel_exposure (
     dt                 date            not null      comment "日期分区"
    ,user_id            bigint(20)      not null      comment "用户id"
    ,period_type        varchar(50)     null          comment "周期类型"
    ,user_type          varchar(200)    null          comment "用户类型"
    ,language2          varchar(50)     null          comment "语言id"
    ,core               int(11)         null          comment "core"
    ,mt                 varchar(50)     null          comment "终端"
    ,recharge_source    varchar(200)    not null      comment "充值来源"
    ,strategy_id        varchar(200)    not null      comment "策略ID"
    ,shop_item_type     varchar(200)    null          comment "档位类型"
    ,zfqd               varchar(200)    null          comment "支付渠道"
    ,etl_ime datetime null default current_timestamp  comment "清洗时间"
)
duplicate key (dt)
comment "海剧三方支付漏斗报表-曝光"
partition by range(dt)
distributed by hash(dt, period_type,user_id) buckets 5
properties (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "month",
"dynamic_partition.time_zone" = "asia/shanghai",
"dynamic_partition.start" = "-2147483648",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "1",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "lz4"
)
;