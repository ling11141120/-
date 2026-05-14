CREATE TABLE `alg_book_describe` (
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `introduce` varchar(1048576) NULL COMMENT "介绍",
  `language_id` int(11) NULL COMMENT "语言",
  `amount` decimal(18, 4) NULL COMMENT "数额"
) ENGINE=OLAP 
PRIMARY KEY(`book_id`)
DISTRIBUTED BY HASH(`book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);