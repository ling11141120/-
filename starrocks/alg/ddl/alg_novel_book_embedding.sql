CREATE TABLE `alg_novel_book_embedding` (
  `book_id` varchar(20) NOT NULL COMMENT "书籍id",
  `language_id` varchar(11) NULL COMMENT "语言id",
  `introduce` varchar(65533) NULL COMMENT "描述",
  `text` varchar(65533) NULL COMMENT "概述",
  `amount` varchar(20) NULL COMMENT "金额",
  `embedding` varchar(65533) NULL COMMENT "",
  `similarity` varchar(65533) NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`book_id`)
COMMENT "书籍信息语义表-test"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);