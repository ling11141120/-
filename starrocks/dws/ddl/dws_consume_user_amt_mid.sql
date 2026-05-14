CREATE TABLE `dws_consume_user_amt_mid` (
  `dt` date NOT NULL COMMENT "数据更新分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `sum_amount_01` int(11) NULL COMMENT "近一天消耗数",
  `con_chap_01` int(11) NULL COMMENT "近1天消耗章节数",
  `sum_amount_07` int(11) NULL COMMENT "近7天消耗数",
  `con_chap_07` int(11) NULL COMMENT "近7天消耗章节数",
  `sum_amount_15` int(11) NULL COMMENT "近15天消耗数",
  `con_chap_15` int(11) NULL COMMENT "近15天消耗章节数",
  `sum_amount` int(11) NULL COMMENT "历史累计消耗数",
  `con_chap` int(11) NULL COMMENT "历史累计消耗章节",
  `etl_time` datetime NULL COMMENT "etl数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `book_id`)
COMMENT "按天统计：用户消耗数量"
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
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "day",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-7",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "5",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
