CREATE TABLE `dws_advertisement_book_cost_amt_ed` (
  `dt` date NOT NULL COMMENT "日期",
  `site_id` int(11) NOT NULL COMMENT "书籍语言",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `book_nature` int(11) NULL COMMENT "书籍类型 3：原创 5：原创拆章",
  `cost_amt` decimal(10, 2) NULL COMMENT "投放金额",
  `etl_tm` datetime NULL COMMENT "清洗时间",
  INDEX index_productid (`site_id`) USING BITMAP COMMENT 'index_site_id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `book_id`)
COMMENT "广告书籍(原创和原创拆章）所投放的费用"
DISTRIBUTED BY HASH(`dt`, `site_id`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
