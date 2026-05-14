CREATE TABLE `dim_book_author` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `book_name` varchar(255) NULL COMMENT "书名",
  `author_id` bigint(20) NULL COMMENT "作者id",
  `author_name` varchar(255) NULL COMMENT "笔名",
  `new_cid` int(11) NULL COMMENT "书籍分类",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `book_id`)
COMMENT "书籍作者维度表"
DISTRIBUTED BY HASH(`product_id`, `book_id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "author_name, book_name",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);