CREATE TABLE `ods_sr_valid_book_info` (
  `lang_id` varchar(500) NOT NULL COMMENT "语言id",
  `book_id` varchar(500) NOT NULL COMMENT "书籍id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`lang_id`, `book_id`)
COMMENT "海阅-有效书籍"
DISTRIBUTED BY HASH(`lang_id`, `book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
