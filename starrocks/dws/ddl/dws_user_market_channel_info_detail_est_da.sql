CREATE TABLE `dws_user_market_channel_info_detail_est_da` (
  `dt` date NOT NULL COMMENT "数据统计时间-西五区分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `mt` int(11) NOT NULL COMMENT "mt",
  `corever` int(11) NOT NULL COMMENT "core",
  `lang2` int(11) NOT NULL COMMENT "投放时语言",
  `first_bookid` bigint(20) NULL COMMENT "首次引流书籍",
  `last_bookid` bigint(20) NULL COMMENT "最新引流书籍",
  `last_source` varchar(100) NULL COMMENT "最新媒体值",
  `isremarket` int(11) NOT NULL COMMENT "是否再营销用户 1：再营销用户  0 非再营销用户",
  `install_date` datetime NOT NULL COMMENT "安装激活时间",
  `updatetime` datetime NOT NULL COMMENT "数据更新变化时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `mt`, `corever`, `lang2`)
COMMENT "投放渠道引流书籍，媒体等数据"
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
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "2",
"bloom_filter_columns" = "updatetime",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-15",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
