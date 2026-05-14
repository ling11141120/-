CREATE TABLE `dwm_user_first_read_book_info_ed` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `fst_read_tm` datetime MIN NULL COMMENT "首次阅读时间",
  `etl_tm` datetime MAX NULL COMMENT "清洗时间"
) ENGINE=OLAP 
AGGREGATE KEY(`product_id`, `user_id`, `book_id`)
COMMENT "阅读-用户首次阅读书籍记录表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
