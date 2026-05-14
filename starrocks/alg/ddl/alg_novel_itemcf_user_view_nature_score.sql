CREATE TABLE `alg_novel_itemcf_user_view_nature_score` (
  `user_id` varchar(500) NOT NULL COMMENT "用户id",
  `book_id` varchar(500) NOT NULL COMMENT "书籍id",
  `language_id` varchar(500) NOT NULL COMMENT "语言id",
  `nature` varchar(500) NULL COMMENT "",
  `create_time` datetime NULL COMMENT "",
  `weight` decimal(10, 2) NULL COMMENT "",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `book_id`, `language_id`)
DISTRIBUTED BY HASH(`user_id`, `book_id`, `language_id`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);