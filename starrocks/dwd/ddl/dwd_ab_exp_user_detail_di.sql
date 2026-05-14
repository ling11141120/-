CREATE TABLE `dwd_ab_exp_user_detail_di` (
  `dt` date NOT NULL COMMENT "日期天分区",
  `exp_id` bigint(20) NOT NULL COMMENT "实验id",
  `exp_grp_id` bigint(20) NOT NULL COMMENT "实验组id",
  `exp_grp_ver_id` bigint(20) NOT NULL COMMENT "实验组版本id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `create_time` datetime NOT NULL COMMENT "时间",
  `etl` datetime NULL COMMENT "数据时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `exp_id`, `exp_grp_id`, `exp_grp_ver_id`, `user_id`)
COMMENT "海剧实验用户明细表"
PARTITION BY RANGE(`dt`)
(PARTITION p202502 VALUES [("2025-02-01"), ("2025-03-01")),
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
PARTITION p202607 VALUES [("2026-07-01"), ("2026-08-01")))
DISTRIBUTED BY HASH(`exp_id`, `exp_grp_id`, `exp_grp_ver_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "MONTH",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-120",
"dynamic_partition.end" = "2",
"dynamic_partition.prefix" = "p",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);