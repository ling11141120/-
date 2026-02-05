drop table if exists dwd.dwd_trade_user_recharge_tier_agg_di;
create table dwd.dwd_trade_user_recharge_tier_agg_di(
     product_id          int           not null comment "product_id"
    ,user_id             bigint        not null comment "用户id"
    ,recharge_tier       decimal(18,2) not null comment "充值档位"
    ,recharge_cnt        int           sum      comment "充值次数"
    ,max_create_time     datetime      max      comment "最大创建时间"
    ,etl_time            datetime               comment "etl时间"
)
aggregate key(product_id, user_id, recharge_tier)
comment '交易域-用户充值档位聚合'
distributed by hash(product_id, user_id, recharge_tier)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "storage_format" = "DEFAULT",
    "enable_persistent_index" = "true",
    "compression" = "LZ4"
)
;