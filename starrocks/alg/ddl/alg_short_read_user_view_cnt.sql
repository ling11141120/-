CREATE TABLE `alg_short_read_user_view_cnt` (
  `user_id` varchar(500) NOT NULL COMMENT "user_id",
  `book_id` varchar(500) NOT NULL COMMENT "书籍id",
  `lang_id` varchar(500) NULL COMMENT "语言id",
  `cnt` bigint(20) NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `book_id`)
DISTRIBUTED BY HASH(`user_id`, `book_id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);