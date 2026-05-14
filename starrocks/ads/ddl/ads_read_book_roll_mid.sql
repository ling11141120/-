CREATE TABLE `ads_read_book_roll_mid` (
  `dt` date NOT NULL COMMENT "dt统计时间分区",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `read_unt_td` bitmap NULL COMMENT "阅读人数",
  `read_pay_unt_td` bitmap NULL COMMENT "付费章节阅读人数",
  `read_chapter_cnt_td` bitmap NULL COMMENT "阅读章节数",
  `read_pay_chapter_cnt_td` bitmap NULL COMMENT "阅读付费章节数",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`)
COMMENT "书籍累计阅读表"
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
DISTRIBUTED BY HASH(`dt`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
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