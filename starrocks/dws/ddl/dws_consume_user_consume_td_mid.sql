CREATE TABLE `dws_consume_user_consume_td_mid` (
  `dt` date NOT NULL COMMENT "统计日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `types` tinyint(4) NOT NULL COMMENT "1:阅币 2：礼券 3：赠送币 4：vip",
  `con_amount` decimal(20, 4) NULL COMMENT "累计消耗",
  `fst_time` datetime NULL COMMENT "首次消费时间",
  `lst_time` datetime NULL COMMENT "最近一次消费时间",
  `consume_cnt` int(11) NULL COMMENT "消费次数",
  `con_chapter_nums` bitmap NULL COMMENT "消费章节数",
  `csum_days_cnt` bitmap NULL COMMENT "消费天数",
  `etl_time` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `types`)
COMMENT "四种解锁方式用户累计消耗指标表"
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
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 15 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-7",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "70",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
