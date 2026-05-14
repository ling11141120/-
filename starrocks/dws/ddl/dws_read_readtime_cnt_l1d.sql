CREATE TABLE `dws_read_readtime_cnt_l1d` (
  `dt` varchar(1048576) NOT NULL COMMENT "",
  `product_id` varchar(65533) NOT NULL COMMENT "",
  `user_id` bigint(20) NOT NULL COMMENT "",
  `mt` varchar(65533) NULL COMMENT "",
  `app_ver` varchar(65533) NULL COMMENT "",
  `chapter_cnt` bigint(20) NOT NULL COMMENT "",
  `times` bigint(20) NULL COMMENT "",
  `avg_times` decimal(38, 9) NULL COMMENT "",
  `percentile_cnt` int(11) NULL COMMENT "中位数",
  `etl_tm` datetime NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
