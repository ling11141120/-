CREATE TABLE `dws_srsv_user_ads_book_a` (
  `dt` date NOT NULL COMMENT "数据统计时间-分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `mt` int(11) NOT NULL COMMENT "mt",
  `corever` int(11) NOT NULL COMMENT "core",
  `lang2` int(11) NOT NULL COMMENT "投放时语言",
  `last_bookid` bigint(20) NULL COMMENT "最新引流书籍",
  `lst_install_date` datetime NOT NULL COMMENT "最新安装激活时间",
  `updatetime` datetime NOT NULL COMMENT "数据更新变化时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `mt`, `corever`, `lang2`)
COMMENT "海阅、海剧投放归因用户最新引流书籍数据,应用于实时人群包数据"
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
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 15 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "updatetime",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-15",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "15",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
