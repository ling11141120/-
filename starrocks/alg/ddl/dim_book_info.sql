CREATE TABLE `dim_book_info` (
  `dt` date NULL COMMENT "日期",
  `book_id` bigint(20) NULL COMMENT "用户ID",
  `category` bigint(20) NULL COMMENT "书籍ID"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `book_id`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 16 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);