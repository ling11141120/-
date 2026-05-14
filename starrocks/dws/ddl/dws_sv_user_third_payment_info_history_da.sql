CREATE TABLE `dws_sv_user_third_payment_info_history_da` (
  `dt` date NOT NULL COMMENT "分区日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `payment_code` int(11) NOT NULL COMMENT "支付方式id",
  `history_payment` varchar(1024) NULL COMMENT "历史支付方式",
  `order_num` int(11) NULL COMMENT "订单数",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `payment_code`)
COMMENT "海剧用户订单支付方式历史数据统计"
PARTITION BY RANGE(`dt`)
(PARTITION p20260507 VALUES [("2026-05-07"), ("2026-05-08")),
PARTITION p20260508 VALUES [("2026-05-08"), ("2026-05-09")),
PARTITION p20260509 VALUES [("2026-05-09"), ("2026-05-10")),
PARTITION p20260510 VALUES [("2026-05-10"), ("2026-05-11")),
PARTITION p20260511 VALUES [("2026-05-11"), ("2026-05-12")),
PARTITION p20260512 VALUES [("2026-05-12"), ("2026-05-13")),
PARTITION p20260513 VALUES [("2026-05-13"), ("2026-05-14")),
PARTITION p20260514 VALUES [("2026-05-14"), ("2026-05-15")),
PARTITION p20260515 VALUES [("2026-05-15"), ("2026-05-16")),
PARTITION p20260516 VALUES [("2026-05-16"), ("2026-05-17")),
PARTITION p20260517 VALUES [("2026-05-17"), ("2026-05-18")))
DISTRIBUTED BY HASH(`dt`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-7",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
