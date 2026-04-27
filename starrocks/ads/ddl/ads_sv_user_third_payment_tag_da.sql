CREATE TABLE `ads_sv_user_third_payment_tag_da` (
  `dt` date NOT NULL COMMENT "分区日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `history_payment` varchar(1024) NULL COMMENT "历史支付方式",
  `third_payment_order` int(11) NULL COMMENT "历史三方支付订单数量",
  `third_payment_proportion` int(11) NULL COMMENT "三方支付订单数占比",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据更新时间"
) ENGINE=OLAP
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "海剧人群包三方支付相关标签"
PARTITION BY RANGE(`dt`)
(PARTITION p20260406 VALUES [("2026-04-06"), ("2026-04-07")),
PARTITION p20260407 VALUES [("2026-04-07"), ("2026-04-08")),
PARTITION p20260408 VALUES [("2026-04-08"), ("2026-04-09")),
PARTITION p20260409 VALUES [("2026-04-09"), ("2026-04-10")),
PARTITION p20260410 VALUES [("2026-04-10"), ("2026-04-11")),
PARTITION p20260411 VALUES [("2026-04-11"), ("2026-04-12")),
PARTITION p20260412 VALUES [("2026-04-12"), ("2026-04-13")),
PARTITION p20260413 VALUES [("2026-04-13"), ("2026-04-14")),
PARTITION p20260414 VALUES [("2026-04-14"), ("2026-04-15")),
PARTITION p20260415 VALUES [("2026-04-15"), ("2026-04-16")),
PARTITION p20260416 VALUES [("2026-04-16"), ("2026-04-17")))
DISTRIBUTED BY HASH(`dt`, `user_id`) BUCKETS 1
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-7",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);