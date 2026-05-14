CREATE TABLE `ads_sr_book_url_cost_total_history_da` (
  `dt` date NOT NULL COMMENT "统计日期(西五区)",
  `product_id` int(11) NOT NULL COMMENT "项目id",
  `source` varchar(255) NOT NULL COMMENT "渠道",
  `book_id` bigint(20) NOT NULL COMMENT "书id",
  `page_id` bigint(20) NOT NULL COMMENT "pageid",
  `url` varchar(65533) NOT NULL COMMENT "url",
  `cost_amount` decimal(16, 2) NULL COMMENT "投放花费",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `source`, `book_id`)
COMMENT "广告书籍最大花费url"
DISTRIBUTED BY HASH(`product_id`, `book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);