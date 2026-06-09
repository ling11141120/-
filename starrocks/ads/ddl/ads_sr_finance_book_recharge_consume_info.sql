create table if not exists ads.ads_sr_finance_book_recharge_consume_info (
     dt                date                                     comment "日期"
    ,product_id        int                                      comment "产品id"
    ,user_id           bigint                                   comment "用户id"
    ,book_id           bigint                                   comment "书籍id"
    ,order_id          varchar(255)                             comment "订单id"
    ,coo_order_id      varchar(255)                             comment "coo_订单id"
    ,shop_item_id      varchar(50)                              comment "商品id"
    ,report_type       int                                      comment "数据类型（1充值，2消耗）"
    ,amount            decimal(12, 2)                           comment "花费金额(阅币)"
    ,remain_amount     decimal(12, 2)                           comment "剩余金额(阅币)-根据mobo订单处理后"
    ,remain_amount_all decimal(12, 2)                           comment "剩余金额(阅币)-原始全量流水(不更新该字段)"
    ,cost              decimal(12, 2)                           comment "流水金额"
    ,test_flag         int                                      comment "测试标识（0非测试，1测试）"
    ,order_time        datetime                                 comment "订单时间"
    ,expiration_time   datetime                                 comment "到期时间"
    ,duration_time     int                                      comment "订单持续时间(到期时间-订单时间)"
    ,etl_time          datetime       default current_timestamp comment "etl时间"
)
duplicate key(dt)
comment "财务-书籍用户进销存明细"
partition by range(dt)
(partition p202606 values less than ("2026-07-01"))
distributed by hash(dt) buckets 3
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
