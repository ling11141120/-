CREATE TABLE `dim_content_book_parentbook_relation` (
  `product_id` bigint(20) NOT NULL COMMENT "产品ID，书籍ID所属的产品ID，例如3322,3311等",
  `book_id` bigint(20) NOT NULL COMMENT "书籍ID",
  `parent_book_id` bigint(20) NOT NULL COMMENT "父级书ID",
  `root_parent_book_id` bigint(20) NOT NULL COMMENT "根父级书ID",
  `language_id` int(11) NOT NULL COMMENT "产品语言",
  `create_time` datetime NOT NULL COMMENT "数据生成时间",
  `update_time` datetime NOT NULL COMMENT "数据修改时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `book_id`)
COMMENT "内容域--拆章书与源书的关系表"
DISTRIBUTED BY HASH(`product_id`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "language_id",
"in_memory" = "true",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);