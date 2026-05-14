CREATE TABLE `ads_read_book_readtime_mid` (
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `read_day_td` bigint(20) NULL COMMENT "累计阅读天数",
  `read_time_td` bigint(20) NULL COMMENT "累计阅读时长",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`book_id`)
COMMENT "书籍累计阅读时长表"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);