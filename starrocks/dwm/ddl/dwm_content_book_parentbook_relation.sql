CREATE TABLE `dwm_content_book_parentbook_relation` (
  `book_id_language_id` bigint(20) NOT NULL COMMENT "书籍ID拼接书籍语言ID",
  `parent_book_id` bigint(20) NOT NULL COMMENT "父级书ID",
  `root_parent_book_id` bigint(20) NOT NULL COMMENT "根父级书ID",
  `product_id` bigint(20) NOT NULL COMMENT "产品ID",
  `book_id` bigint(20) NOT NULL COMMENT "书籍ID",
  `book_language_id` int(11) NOT NULL COMMENT "书籍语言ID",
  `language_id` int(11) NOT NULL COMMENT "产品语言",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`book_id_language_id`)
COMMENT "内容域--拆章书与源书的关系表--小时全量表"
DISTRIBUTED BY HASH(`book_id_language_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_language_id, book_id_language_id",
"colocate_with" = "dwm_content_book_relations",
"in_memory" = "true",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
