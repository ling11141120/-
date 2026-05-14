CREATE TABLE `sample_repay_data_v3` (
  `dt` date NULL COMMENT "",
  `user_id` bigint(20) NULL COMMENT "",
  `label` int(11) NULL COMMENT "",
  `regdays` int(11) NULL COMMENT "",
  `first_pay_money` decimal(10, 2) NULL COMMENT "",
  `pay_total` bigint(20) NULL COMMENT "",
  `pay_max` int(11) NULL COMMENT "",
  `pay_min` int(11) NULL COMMENT "",
  `pay_avg` decimal(38, 9) NULL COMMENT "",
  `pay_num` bigint(20) NULL COMMENT "",
  `pay_times` int(11) NULL COMMENT "",
  `read_book_num` bigint(20) NULL COMMENT "",
  `read_chpts` bigint(20) NULL COMMENT "",
  `max_chpts` int(11) NULL COMMENT "",
  `con_chapter_num` bigint(20) NULL COMMENT "",
  `csum_total_amount` bigint(20) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `user_id`, `label`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 14 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);