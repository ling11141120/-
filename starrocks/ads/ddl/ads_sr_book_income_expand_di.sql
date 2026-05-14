CREATE TABLE `ads_sr_book_income_expand_di` (
  `dt` date NOT NULL COMMENT "日期(事件时间)",
  `md5_key` varchar(512) NOT NULL COMMENT "md5_key,主键",
  `product_id` int(11) NULL COMMENT "产品id",
  `income_type` int(11) NULL COMMENT "收入类型",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `lang_id` int(11) NULL COMMENT "语言id",
  `author_id` bigint(20) NULL COMMENT "作者id",
  `book_name` varchar(65533) NULL COMMENT "书名",
  `PenName` varchar(65533) NULL COMMENT "作者笔名",
  `AuthorSale` decimal(18, 2) NULL COMMENT "收入",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `md5_key`)
COMMENT "海阅收支数据"
DISTRIBUTED BY HASH(`dt`, `md5_key`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);