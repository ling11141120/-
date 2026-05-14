CREATE TABLE `alg_novel_nature_sort` (
  `book_id` varchar(255) NOT NULL COMMENT "书籍id",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `nature` varchar(500) NULL COMMENT "",
  `price` decimal(12, 2) NULL COMMENT "花费",
  `rank` int(11) NULL COMMENT "语言+类型正序"
) ENGINE=OLAP 
PRIMARY KEY(`book_id`, `language_id`)
DISTRIBUTED BY HASH(`book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);