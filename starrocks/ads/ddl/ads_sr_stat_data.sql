CREATE TABLE `ads_sr_stat_data` (
  `product_id` int(11) NOT NULL COMMENT "",
  `auto_id` bigint(20) NOT NULL COMMENT "",
  `book_id` bigint(20) NOT NULL COMMENT "",
  `language_id` int(11) NOT NULL COMMENT "",
  `stat_field` varchar(150) NULL COMMENT "",
  `rank_class` varchar(150) NULL COMMENT "",
  `code` int(11) NULL COMMENT "",
  `value` bigint(20) NULL COMMENT "",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `auto_id`)
DISTRIBUTED BY HASH(`product_id`, `auto_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);