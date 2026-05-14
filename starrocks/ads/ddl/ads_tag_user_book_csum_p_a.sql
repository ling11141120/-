CREATE TABLE `ads_tag_user_book_csum_p_a` (
  `dt` date NOT NULL COMMENT "分区，统计时间",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `csum_tp` int(11) NOT NULL COMMENT "消耗类型统计 1: 阅币加礼券的消耗 2：阅币的消耗",
  `csum_amt` int(11) NULL COMMENT "消耗货币数",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `book_id`, `csum_tp`)
COMMENT "阅读-用户消耗阅币+礼券，消耗阅币最多的对应的书籍 "
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
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 25 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "day",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-7",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "25",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);