CREATE TABLE `alg_reader_repay_book_feature` (
  `dt` date NOT NULL COMMENT "",
  `book_id` bigint(20) NOT NULL COMMENT "",
  `site_id` int(11) NOT NULL COMMENT "",
  `book_length` bigint(20) NULL COMMENT "",
  `newc_id` varchar(65533) NULL COMMENT "",
  `newc_name` varchar(65533) NULL COMMENT "",
  `sexy2` varchar(65533) NULL COMMENT "",
  `total_read_num` varchar(65533) NULL COMMENT "",
  `pay_num` varchar(65533) NULL COMMENT "",
  `success_pay_num` varchar(65533) NULL COMMENT "",
  `amount` varchar(65533) NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`, `site_id`)
COMMENT "海阅-用户首充明细表"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "ZSTD"
);