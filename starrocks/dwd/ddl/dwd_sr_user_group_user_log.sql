CREATE TABLE `dwd_sr_user_group_user_log` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `group_id` int(11) NOT NULL COMMENT "人群包 id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `start_time` datetime NOT NULL COMMENT "入包时间",
  `end_time` datetime NULL COMMENT "出包时间",
  `etl_tm` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP
PRIMARY KEY(`product_id`, `group_id`, `user_id`, `start_time`)
COMMENT "海阅-人群包出入包归因记录"
PARTITION BY RANGE(`start_time`)
(PARTITION p202404 VALUES [("2024-04-01 00:00:00"), ("2024-05-01 00:00:00")),
PARTITION p202405 VALUES [("2024-05-01 00:00:00"), ("2024-06-01 00:00:00")),
PARTITION p202406 VALUES [("2024-06-01 00:00:00"), ("2024-07-01 00:00:00")),
PARTITION p202407 VALUES [("2024-07-01 00:00:00"), ("2024-08-01 00:00:00")),
PARTITION p202408 VALUES [("2024-08-01 00:00:00"), ("2024-09-01 00:00:00")),
PARTITION p202409 VALUES [("2024-09-01 00:00:00"), ("2024-10-01 00:00:00")),
PARTITION p202410 VALUES [("2024-10-01 00:00:00"), ("2024-11-01 00:00:00")),
PARTITION p202411 VALUES [("2024-11-01 00:00:00"), ("2024-12-01 00:00:00")),
PARTITION p202412 VALUES [("2024-12-01 00:00:00"), ("2025-01-01 00:00:00")),
PARTITION p202501 VALUES [("2025-01-01 00:00:00"), ("2025-02-01 00:00:00")),
PARTITION p202502 VALUES [("2025-02-01 00:00:00"), ("2025-03-01 00:00:00")),
PARTITION p202503 VALUES [("2025-03-01 00:00:00"), ("2025-04-01 00:00:00")),
PARTITION p202504 VALUES [("2025-04-01 00:00:00"), ("2025-05-01 00:00:00")),
PARTITION p202505 VALUES [("2025-05-01 00:00:00"), ("2025-06-01 00:00:00")),
PARTITION p202506 VALUES [("2025-06-01 00:00:00"), ("2025-07-01 00:00:00")),
PARTITION p202507 VALUES [("2025-07-01 00:00:00"), ("2025-08-01 00:00:00")),
PARTITION p202508 VALUES [("2025-08-01 00:00:00"), ("2025-09-01 00:00:00")),
PARTITION p202509 VALUES [("2025-09-01 00:00:00"), ("2025-10-01 00:00:00")),
PARTITION p202510 VALUES [("2025-10-01 00:00:00"), ("2025-11-01 00:00:00")),
PARTITION p202511 VALUES [("2025-11-01 00:00:00"), ("2025-12-01 00:00:00")),
PARTITION p202512 VALUES [("2025-12-01 00:00:00"), ("2026-01-01 00:00:00")),
PARTITION p202601 VALUES [("2026-01-01 00:00:00"), ("2026-02-01 00:00:00")),
PARTITION p202602 VALUES [("2026-02-01 00:00:00"), ("2026-03-01 00:00:00")),
PARTITION p202603 VALUES [("2026-03-01 00:00:00"), ("2026-04-01 00:00:00")),
PARTITION p202604 VALUES [("2026-04-01 00:00:00"), ("2026-05-01 00:00:00")),
PARTITION p202605 VALUES [("2026-05-01 00:00:00"), ("2026-06-01 00:00:00")),
PARTITION p202606 VALUES [("2026-06-01 00:00:00"), ("2026-07-01 00:00:00")),
PARTITION p202607 VALUES [("2026-07-01 00:00:00"), ("2026-08-01 00:00:00")))
DISTRIBUTED BY HASH(`product_id`, `group_id`, `user_id`) BUCKETS 10
PROPERTIES (
"replication_num" = "2",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "Month",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-24",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "910",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);