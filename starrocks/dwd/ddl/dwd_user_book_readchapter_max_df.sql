CREATE TABLE `dwd_user_book_readchapter_max_df` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `max_serial_number` bigint(20) NULL COMMENT "最大章节序号",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`, `book_id`)
COMMENT "用户阅读书籍最大章节数（90天前-昨天）"
DISTRIBUTED BY HASH(`product_id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);