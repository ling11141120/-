CREATE TABLE `dws_video_user_consume_series_last3_td` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户Id",
  `last_rn` int(11) NOT NULL COMMENT "最后消费排序",
  `series_id` bigint(20) NOT NULL COMMENT "剧Id",
  `consume_value` int(11) NOT NULL COMMENT "消费数量",
  `remaining_epis` int(11) NOT NULL COMMENT "剩余剧集",
  `create_time` datetime NULL COMMENT "创建时间（观看时间）",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `last_rn`)
COMMENT "海剧-用户消费最多三条剧集"
PARTITION BY RANGE(`dt`)
(PARTITION p20260429 VALUES [("2026-04-29"), ("2026-04-30")),
PARTITION p20260430 VALUES [("2026-04-30"), ("2026-05-01")),
PARTITION p20260501 VALUES [("2026-05-01"), ("2026-05-02")),
PARTITION p20260502 VALUES [("2026-05-02"), ("2026-05-03")),
PARTITION p20260503 VALUES [("2026-05-03"), ("2026-05-04")),
PARTITION p20260504 VALUES [("2026-05-04"), ("2026-05-05")),
PARTITION p20260505 VALUES [("2026-05-05"), ("2026-05-06")),
PARTITION p20260506 VALUES [("2026-05-06"), ("2026-05-07")),
PARTITION p20260507 VALUES [("2026-05-07"), ("2026-05-08")),
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
DISTRIBUTED BY HASH(`dt`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "day",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-15",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "1",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
