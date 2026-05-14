CREATE TABLE `ads_sr_alg_user_preference_book_da` (
  `product_id` int(11) NOT NULL COMMENT "项目id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `most_read_book` bigint(20) NULL COMMENT "阅读章节最多的书",
  `most_consume_book` bigint(20) NULL COMMENT "消耗最多的书",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "海阅PUSH，用户书籍行为-阅读、消耗"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);