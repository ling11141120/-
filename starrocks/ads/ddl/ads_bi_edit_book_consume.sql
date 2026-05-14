CREATE TABLE `ads_bi_edit_book_consume` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `site_id` int(11) NOT NULL COMMENT "书籍语言",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `book_nature` int(11) NULL COMMENT "书籍类型",
  `money_amount` decimal(10, 2) NULL COMMENT "阅币消耗金额",
  `vip_amount` decimal(10, 2) NULL COMMENT "vip金额",
  `gift_amount` decimal(10, 2) NULL COMMENT "礼券金额",
  `award_amount` decimal(10, 2) NULL COMMENT "赠送币金额",
  `total_amount` decimal(10, 2) NULL COMMENT "合计金额",
  `etl_time` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `site_id`, `book_id`)
COMMENT "服务端编辑后台-书籍消耗表"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);