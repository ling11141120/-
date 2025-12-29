drop table if exists ads.ads_ad_user_space_conversion_detail;
create table ads.ads_ad_user_space_conversion_detail (
     dt                  date           not null                     comment "时间"
    ,user_id             bigint(20)     not null                     comment "登录id"
    ,ad_position_id      varchar(60)    not null                     comment "广告位id"
    ,ad_strategy_id      varchar(60)    not null                     comment "策略id"
    ,main_strategy_id    varchar(60)    not null                     comment "主策略id"
    ,ad_type             varchar(60)    not null                     comment "广告类型"
    ,period_type         varchar(60)    not null                     comment "周期类型"
    ,user_type           varchar(60)                                 comment "用户类型"
    ,put_language        varchar(60)                                 comment "投放语言"
    ,country_leve        varchar(60)                                 comment "国家等级"
    ,mt                  varchar(60)                                 comment "终端"
    ,corever             varchar(60)                                 comment "core"
    ,impression_pv       int(11)                                     comment "曝光pv"
    ,click_pv            int(11)                                     comment "点击pv"
    ,watch_completion_pv int(11)                                     comment "观看完成pv"
    ,ad_revenue_pv       bigint(20)                                  comment "广告收益pv"
    ,ad_revenue_amount   decimal(12, 6)                              comment "广告收益"
    ,etl_time            datetime       default current_timestamp    comment "清洗时间"
)
primary key (dt, user_id, ad_position_id, ad_strategy_id, main_strategy_id, ad_type, period_type)
comment "用户广告位转化明细"
partition by range (dt)
distributed by hash (user_id) buckets 3
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;