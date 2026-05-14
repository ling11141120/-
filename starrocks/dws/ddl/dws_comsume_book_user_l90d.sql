CREATE TABLE `dws_comsume_book_user_l90d` (
  `dt` date NOT NULL COMMENT "统计日期,书的阅读日期",
  `site_id` bigint(20) NOT NULL COMMENT "语言id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `book_id`, `user_id`)
COMMENT "书籍的90日内首次消耗用户表"
DISTRIBUTED BY HASH(`site_id`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
