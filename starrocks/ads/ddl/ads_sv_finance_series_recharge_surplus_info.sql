create table if not exists ads.ads_sv_finance_series_recharge_surplus_info (
     aging_dt        date                                     comment "账龄存点日期"
    ,order_dt        date                                     comment "日期"
    ,product_id      int                                      comment "产品id"
    ,user_id         bigint                                   comment "用户id"
    ,order_id        varchar(255)                             comment "订单id"
    ,coo_order_id    varchar(255)                             comment "coo_订单id"
    ,shop_item_id    varchar(50)                              comment "商品id"
    ,amount          decimal(12, 2)                           comment "花费金额(观看币)"
    ,surplus         decimal(12, 2)                           comment "结余"
    ,cost            decimal(12, 2)                           comment "流水金额"
    ,test_flag       int                                      comment "测试标识（0非测试，1测试）"
    ,order_time      datetime                                 comment "订单时间"
    ,expiration_time datetime                                 comment "到期时间"
    ,duration_time   int                                      comment "订单持续时间(到期时间-订单时间)"
    ,etl_time        datetime       default current_timestamp comment "etl时间"
)
duplicate key(aging_dt, order_dt)
comment "财务-短剧用户进销存-充值结余"
distributed by hash(aging_dt, order_dt) buckets 30
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
