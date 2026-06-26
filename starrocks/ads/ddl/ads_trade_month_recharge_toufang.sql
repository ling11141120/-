create if not exists table ads.ads_trade_month_recharge_toufang (
     month            int            not null                  comment "月份"
    ,product_id       int            not null                  comment "产品id"
    ,charge_money     decimal(20, 6)                           comment "分成后充值金额"
    ,charge_itemcount int                                      comment "分成前充值金额"
    ,Spend            decimal(20, 6)                           comment "投放金额(推广费用)"
    ,etl_time         datetime       default current_timestamp comment "etl清洗时间"
)
primary key(month, product_id)
comment "混合域每月充值投放指标表"
distributed by hash(month, product_id) buckets 20
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;