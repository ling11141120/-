CREATE TABLE `dws_consume_book_consume_ed` (
  `dt` date NOT NULL COMMENT "统计日期",
  `types` int(11) NOT NULL COMMENT "消耗类型",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `site_id` int(11) NOT NULL COMMENT "区分多语言",
  `amount` int(11) NULL COMMENT "1日消耗数量",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_types (`types`) USING BITMAP COMMENT 'index_types'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `types`, `book_id`, `site_id`)
COMMENT "消耗域书籍粒度消耗1日汇总表"
DISTRIBUTED BY HASH(`book_id`, `site_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "site_id, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
