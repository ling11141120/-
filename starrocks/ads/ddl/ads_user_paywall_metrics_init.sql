create table if not exists ads.ads_user_paywall_metrics_init (
     product_id                  int         not null                     comment "产品id"
    ,user_id                     bigint      not null                     comment "用户id"
    ,first_recharge_time         bigint                                   comment "首充时间戳，毫秒"
    ,first_recharge_type         int                                      comment "首充类型，0普通充值，1VIP，2签到卡，8SVIP"
    ,first_vip_recharge_date     bigint                                   comment "首次VIP充值时间戳，毫秒"
    ,last_recharge_type          int                                      comment "最近一次充值类型，0普通充值，1VIP，2签到卡，8SVIP"
    ,etl_time                    datetime    default current_timestamp    comment "清洗时间"
)
primary key(product_id, user_id)
comment "用户域-付费墙用户指标初始化"
distributed by hash(product_id, user_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
