CREATE TABLE `ads_sr_book_income_expand_di_mid` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `book_type` int(11) NOT NULL COMMENT "书籍类型",
  `lang_id` int(11) NOT NULL COMMENT "书籍语言",
  `author_id` bigint(20) NULL COMMENT "作者id",
  `book_name` varchar(65533) NULL COMMENT "书名",
  `book_code` varchar(65533) NULL COMMENT "书籍代号",
  `is_put` int(11) NULL COMMENT "是否上架",
  `put_down_level` int(11) NULL COMMENT "下架等级",
  `author_name` varchar(65533) NULL COMMENT "作者笔名",
  `author_type` int(11) NULL COMMENT "作者类型",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `book_id`, `book_type`, `lang_id`)
COMMENT "海阅收支数据"
DISTRIBUTED BY HASH(`product_id`, `book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);