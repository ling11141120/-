CREATE TABLE `alg_novel_book_list_top20` (
  `book_id` varchar(200) NOT NULL COMMENT "书籍id",
  `book_code` varchar(200) NULL COMMENT "书籍代号",
  `book_name` varchar(200) NOT NULL COMMENT "书籍名称",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `price` decimal(14, 2) NOT NULL COMMENT "花费",
  `rank` int(11) NOT NULL COMMENT "语言+花费倒序"
) ENGINE=OLAP 
PRIMARY KEY(`book_id`)
DISTRIBUTED BY HASH(`book_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);