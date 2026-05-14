CREATE TABLE `ads_edm_user_info_ed_bookshelftouser_tmp` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`, `book_id`)
COMMENT "用户云书架记录"
DISTRIBUTED BY HASH(`product_id`, `user_id`, `book_id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id, product_id, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);