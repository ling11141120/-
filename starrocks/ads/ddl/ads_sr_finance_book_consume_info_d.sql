CREATE TABLE `ads_sr_finance_book_consume_info_d` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `product_type_name` varchar(255) NOT NULL COMMENT "产品名称",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `book_name` varchar(255) NULL COMMENT "书籍名称",
  `language_id` int(11) NULL COMMENT "语言id",
  `abbreviation` varchar(50) NULL COMMENT "语言名称",
  `amount` decimal(12, 2) NULL COMMENT "花费金额",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `product_type_name`, `book_id`)
COMMENT "财务-书籍消耗明细-日期"
DISTRIBUTED BY HASH(`dt`, `product_id`, `product_type_name`, `book_id`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);