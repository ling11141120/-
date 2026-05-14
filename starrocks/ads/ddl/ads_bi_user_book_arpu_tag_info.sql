CREATE TABLE `ads_bi_user_book_arpu_tag_info` (
  `dt` date NOT NULL COMMENT "统计分区",
  `lang_id` int(11) NOT NULL COMMENT "书籍语言",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `latest_book_d0_ad_coins` decimal(18, 2) NULL COMMENT "最近一次阅读书籍d0引流-阅币消费arpu",
  `latest_book_d0_base_coins` decimal(18, 2) NULL COMMENT "最近一次阅读书籍d0非引流-阅币消费arpu",
  `latest_book_d0_coins` decimal(18, 2) NULL COMMENT "最近一次阅读书籍d0总阅币消费arpu",
  `latest_book_d7_ad_coins` decimal(18, 2) NULL COMMENT "最近一次阅读书籍d7引流-阅币消费arpu",
  `latest_book_d7_base_coins` decimal(18, 2) NULL COMMENT "最近一次阅读书籍d7非引流-阅币消费arpu",
  `latest_book_d7_coins` decimal(18, 2) NULL COMMENT "最近一次阅读书籍d7总阅币消费arpu",
  `latest_book_d7_d0_ad_coins` decimal(18, 2) NULL COMMENT "最近一次阅读书籍d7/d0引流-阅币消费arpu",
  `latest_book_d7_d0_base_coins` decimal(18, 2) NULL COMMENT "最近一次阅读书籍d7/d0非引流-阅币消费arpu",
  `latest_book_d7_d0_coins` decimal(18, 2) NULL COMMENT "最近一次阅读书籍d7/d0阅币消费arpu",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间",
  INDEX index_lang_id (`lang_id`) USING BITMAP COMMENT 'index_lang_id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `lang_id`, `book_id`)
COMMENT "实时人群包-用户书籍标签数据（消耗arpu）"
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
DISTRIBUTED BY HASH(`dt`, `lang_id`, `book_id`) BUCKETS 1 
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