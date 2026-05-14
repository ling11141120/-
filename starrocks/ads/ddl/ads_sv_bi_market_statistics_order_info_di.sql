CREATE TABLE `ads_sv_bi_market_statistics_order_info_di` (
  `dt` date NOT NULL COMMENT "分区日期",
  `order_id` varchar(1024) NOT NULL COMMENT "订单号",
  `app_name` varchar(1024) NULL COMMENT "app名称",
  `mt` varchar(1024) NULL COMMENT "终端",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `create_time` datetime NULL COMMENT "订单创建时间",
  `amount` decimal(16, 2) NULL COMMENT "订单金额",
  `sub_pay_type` varchar(1024) NULL COMMENT "支付渠道",
  `shop_item` varchar(1024) NULL COMMENT "商品类型",
  `is_refund` varchar(1024) NULL COMMENT "是否退款",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `order_id`)
COMMENT "销售统计表KL-充值明细"
PARTITION BY RANGE(`dt`)
(PARTITION p202410 VALUES [("2024-10-01"), ("2024-11-01")),
PARTITION p202411 VALUES [("2024-11-01"), ("2024-12-01")),
PARTITION p202412 VALUES [("2024-12-01"), ("2025-01-01")),
PARTITION p202501 VALUES [("2025-01-01"), ("2025-02-01")),
PARTITION p202502 VALUES [("2025-02-01"), ("2025-03-01")),
PARTITION p202503 VALUES [("2025-03-01"), ("2025-04-01")),
PARTITION p202504 VALUES [("2025-04-01"), ("2025-05-01")),
PARTITION p202505 VALUES [("2025-05-01"), ("2025-06-01")),
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
DISTRIBUTED BY HASH(`dt`, `order_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "MONTH",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-1024",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);