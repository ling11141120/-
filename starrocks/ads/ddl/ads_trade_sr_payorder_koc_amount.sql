CREATE TABLE `ads_trade_sr_payorder_koc_amount` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "项目id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍ID",
  `koc_amount` decimal(16, 4) NULL COMMENT "koc分成金额",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `book_id`)
COMMENT "海阅订单koc分成金额"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);