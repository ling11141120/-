CREATE TABLE `ads_read_book_fst_dt_temp` (
  `dt` date NOT NULL COMMENT "统计日期,书的阅读日期",
  `site_id` bigint(20) NOT NULL COMMENT "语言id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `fst_dt` date NULL COMMENT "书的首次阅读时间",
  `read_unt` bigint(20) NULL COMMENT "阅读人数",
  `etl_tm` datetime NULL COMMENT "处理时间",
  INDEX index_site_id (`site_id`) USING BITMAP COMMENT 'index_site_id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `book_id`)
COMMENT "基于dws_read_90_first_all_read_mid2算书的首次阅读的临时表"
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
DISTRIBUTED BY HASH(`dt`, `site_id`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "day",
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