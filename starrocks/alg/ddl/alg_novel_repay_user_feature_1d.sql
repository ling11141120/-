CREATE TABLE `alg_novel_repay_user_feature_1d` (
  `dt` date NOT NULL COMMENT "",
  `user_id` bigint(20) NOT NULL COMMENT "",
  `product_id` bigint(20) NOT NULL COMMENT "",
  `book_id` bigint(20) NULL COMMENT "",
  `sex` varchar(65533) NULL COMMENT "",
  `mt` varchar(65533) NULL COMMENT "",
  `corever` varchar(65533) NULL COMMENT "",
  `current_language` varchar(65533) NULL COMMENT "",
  `chl` varchar(65533) NULL COMMENT "",
  `ram` varchar(65533) NULL COMMENT "",
  `device` varchar(65533) NULL COMMENT "",
  `brand` varchar(65533) NULL COMMENT "",
  `regdays` varchar(65533) NULL COMMENT "",
  `first_pay_money` varchar(65533) NULL COMMENT "",
  `pay_total` varchar(65533) NULL COMMENT "",
  `pay_max` varchar(65533) NULL COMMENT "",
  `pay_min` varchar(65533) NULL COMMENT "",
  `pay_avg` varchar(65533) NULL COMMENT "",
  `pay_num` varchar(65533) NULL COMMENT "",
  `pay_times` varchar(65533) NULL COMMENT "",
  `read_books_7day` varchar(65533) NULL COMMENT "",
  `read_chapters_7day` varchar(65533) NULL COMMENT "",
  `read_times_7day` varchar(65533) NULL COMMENT "",
  `read_days_7day` varchar(65533) NULL COMMENT "",
  `login_days_7day` varchar(65533) NULL COMMENT "",
  `read_books` varchar(65533) NULL COMMENT "",
  `read_chpts` varchar(65533) NULL COMMENT "",
  `max_chpts` varchar(65533) NULL COMMENT "",
  `con_chapter_num` varchar(65533) NULL COMMENT "",
  `csum_total_amount` varchar(65533) NULL COMMENT "",
  `ecpm` varchar(65533) NULL COMMENT "",
  `itemcount` varchar(65533) NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`, `product_id`)
COMMENT "海阅-用户首充明细表"
DISTRIBUTED BY HASH(`user_id`, `product_id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "ZSTD"
);