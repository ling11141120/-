CREATE TABLE `ads_bi_sr_rechargeexposure_statistics_di` (
  `dt` date NOT NULL COMMENT "统计日期",
  `position` varchar(755) NOT NULL COMMENT "位置",
  `event_strategy_id` int(11) NOT NULL COMMENT "策略id",
  `activity_id` int(11) NOT NULL COMMENT "活动id",
  `user_id` varchar(100) NOT NULL COMMENT "用户id",
  `cnt` int(11) NULL COMMENT "数量",
  `exposure_pv` int(11) NULL COMMENT "曝光PV",
  `exposure_pv_s` int(11) NULL COMMENT "曝光PV-秒",
  `exposure_pv_10s` int(11) NULL COMMENT "曝光PV-10",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `position`, `event_strategy_id`, `activity_id`, `user_id`)
COMMENT "bi，充值档位曝光统计"
PARTITION BY RANGE(`dt`)
(PARTITION p202501 VALUES [("2025-01-01"), ("2025-02-01")),
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
DISTRIBUTED BY HASH(`dt`, `position`, `event_strategy_id`) BUCKETS 3 
PROPERTIES (
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
"storage_medium" = "SSD",
"compression" = "ZSTD"
);