CREATE TABLE `dws_read_user_readtime_a_mid` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户ID",
  `read_day_td` bigint(20) NULL COMMENT "累计阅读天数",
  `read_time_td` bigint(20) NULL COMMENT "累计阅读时间",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "用户累计阅读时长表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
