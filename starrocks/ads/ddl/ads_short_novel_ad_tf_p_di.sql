CREATE TABLE `ads_short_novel_ad_tf_p_di` (
  `dt` date NOT NULL COMMENT "数据所属的时间分区",
  `book_id` bigint(20) NOT NULL COMMENT "书籍ID",
  `ad_tf_amount` decimal(20, 4) NOT NULL COMMENT "广告投放金额",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`)
COMMENT "短篇小说广告投放金额--每天汇总"
PARTITION BY RANGE(`dt`)
(PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "year",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-12",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "1",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);