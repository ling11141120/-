CREATE TABLE `ads_user_read_roll_mid` (
  `product_id` int(11) NULL COMMENT "产品id",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `last_read_time` datetime MAX NULL COMMENT "最大阅读时间",
  `etl_time` datetime MAX NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
AGGREGATE KEY(`product_id`, `user_id`, `book_id`)
COMMENT "用户最后阅读书籍时间表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);