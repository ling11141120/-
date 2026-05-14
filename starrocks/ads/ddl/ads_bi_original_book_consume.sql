CREATE TABLE `ads_bi_original_book_consume` (
  `dt` date NOT NULL COMMENT "日期",
  `site_id` int(11) NOT NULL COMMENT "",
  `book_nature` int(11) NOT NULL COMMENT "书籍类型 3:原创 5:原创拆章",
  `money_amount` decimal(10, 2) NULL COMMENT "阅币消耗金额",
  `vip_amount` decimal(10, 2) NULL COMMENT "vip金额",
  `gift_amount` decimal(10, 2) NULL COMMENT "礼券金额",
  `award_amount` decimal(10, 2) NULL COMMENT "赠送币金额",
  `total_amount` decimal(10, 2) NULL COMMENT "合计金额",
  `reward_sale` decimal(10, 2) NULL COMMENT "打赏收入",
  `remuneration_money` decimal(10, 2) NULL COMMENT "作者稿酬",
  `etl_time` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `book_nature`)
COMMENT "服务端编辑后台-原创书籍消耗表"
DISTRIBUTED BY HASH(`dt`, `site_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);