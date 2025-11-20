drop table if exists ads.ads_sv_third_party_payment_funnel_recharge;
create table ads.ads_sv_third_party_payment_funnel_recharge (
     dt                 date            not null      comment "日期分区"
    ,user_id            bigint(20)      not null      comment "用户id"
    ,period_type        varchar(50)     not null      comment "周期类型"
    ,order_id           varchar(255)    not null      comment "订单id"
    ,user_type          varchar(200)                  comment "用户类型"
    ,language2          varchar(50)                   comment "语言id"
    ,core               int(11)                       comment "core"
    ,mt                 varchar(50)                   comment "终端"
    ,create_time        datetime                      comment "创建时间"
    ,recharge_source    varchar(200)                  comment "充值来源"
    ,strategy_id        varchar(200)    not null      comment "策略ID"
    ,shop_item_type     varchar(200)                  comment "档位类型"
    ,zfqd               varchar(200)                  comment "支付渠道"
    ,if_third           int(11)                       comment ""
    ,subscribe_status   int(11)                       comment ""
    ,time_duration      int(11)                       comment ""
    ,base_amount        decimal(12,2)                 comment ""
    ,etl_ime datetime null default current_timestamp  comment "清洗时间"
)
primary key(dt, user_id, period_type, order_id)
comment "海剧三方支付漏斗报表-充值成功"
distributed by hash(dt, period_type, user_id) buckets 5
partition by date_trunc('month',dt)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;