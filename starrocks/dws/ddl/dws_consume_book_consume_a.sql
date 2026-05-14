CREATE TABLE `dws_consume_book_consume_a` (
  `dt` date NOT NULL COMMENT "统计日期",
  `types` int(11) NOT NULL COMMENT "消耗类型",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `site_id` int(11) NOT NULL COMMENT "区分多语言",
  `consume_td` int(11) NULL COMMENT "累计消耗数量",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_types (`types`) USING BITMAP COMMENT 'index_types'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `types`, `book_id`, `site_id`)
COMMENT "消耗域书籍粒度消耗累计汇总表"
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
DISTRIBUTED BY HASH(`book_id`, `site_id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "site_id, book_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-7",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "1",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
