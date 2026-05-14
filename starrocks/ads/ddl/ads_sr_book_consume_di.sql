CREATE TABLE `ads_sr_book_consume_di` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `consume_amount` int(11) NULL COMMENT "消耗（阅币+礼券）",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `language_id`, `book_id`)
COMMENT "书籍阅币、礼券消耗(近1个月)"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);