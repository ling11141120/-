CREATE TABLE `dwd_sv_tt_payorder_info` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `settle_dt` date NOT NULL COMMENT "结算日期",
  `trade_order_id` varchar(100) NOT NULL COMMENT "订单id",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `core` int(11) NULL COMMENT "core",
  `mt` int(11) NULL COMMENT "mt",
  `reg_country` varchar(100) NULL COMMENT "注册国家",
  `vip_type` int(11) NULL COMMENT "充值类型（0 普通充值 1 月卡 2 季卡 3 年卡 4 周卡）",
  `shop_item_id` int(11) NULL COMMENT "区分不同充值类型：（0：充值，800：签到卡，810：SVIP，830:福利包，840：新福利包，860：NSVIP）",
  `series_id` int(11) NULL COMMENT "剧id",
  `recharge_amt` decimal(20, 12) NULL COMMENT "充值金额",
  `monthly_recharge_amt` decimal(20, 12) NULL COMMENT "充值金额-按月结算",
  `net_amt` decimal(20, 12) NULL COMMENT "到手金额",
  `monthly_net_amt` decimal(20, 12) NULL COMMENT "到手金额-按月结算",
  `is_refund` int(11) NULL COMMENT "是否为退款订单 0否 1是",
  `is_sandbox` int(11) NULL COMMENT "是否为沙盒订单 0否 1是",
  `create_time` datetime NULL COMMENT "创建时间",
  `settle_time` datetime NULL COMMENT "结算时间",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `settle_dt`, `trade_order_id`)
COMMENT "海剧-TT小程序充值明细"
PARTITION BY RANGE(`dt`)
(PARTITION p202505 VALUES [("2025-05-01"), ("2025-06-01")),
PARTITION p202506 VALUES [("2025-06-01"), ("2025-07-01")),
PARTITION p202507 VALUES [("2025-07-01"), ("2025-08-01")),
PARTITION p202508 VALUES [("2025-08-01"), ("2025-09-01")),
PARTITION p202509 VALUES [("2025-09-01"), ("2025-10-01")),
PARTITION p202510 VALUES [("2025-10-01"), ("2025-11-01")),
PARTITION p202511 VALUES [("2025-11-01"), ("2025-12-01")),
PARTITION p202512 VALUES [("2025-12-01"), ("2026-01-01")),
PARTITION p202601 VALUES [("2026-01-01"), ("2026-02-01")),
PARTITION p202602 VALUES [("2026-02-01"), ("2026-03-01")),
PARTITION p202603 VALUES [("2026-03-01"), ("2026-04-01")),
PARTITION p202604 VALUES [("2026-04-01"), ("2026-05-01")),
PARTITION p202605 VALUES [("2026-05-01"), ("2026-06-01")),
PARTITION p202606 VALUES [("2026-06-01"), ("2026-07-01")),
PARTITION p202607 VALUES [("2026-07-01"), ("2026-08-01")),
PARTITION p202608 VALUES [("2026-08-01"), ("2026-09-01")))
DISTRIBUTED BY HASH(`dt`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "month",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-2147483648",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);