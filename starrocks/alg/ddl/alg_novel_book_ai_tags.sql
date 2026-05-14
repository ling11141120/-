CREATE TABLE `alg_novel_book_ai_tags` (
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `language_id` int(11) NULL COMMENT "语言id",
  `amount` bigint(20) NULL COMMENT "金额",
  `describe` varchar(65533) NULL COMMENT "描述",
  `tags` varchar(65533) NULL COMMENT "标签"
) ENGINE=OLAP 
PRIMARY KEY(`book_id`)
COMMENT "书籍信息表"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);