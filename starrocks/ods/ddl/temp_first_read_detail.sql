CREATE TABLE `temp_first_read_detail` (
  `dt` date NULL COMMENT "",
  `product_id` bigint(20) NULL COMMENT "",
  `user_id` varchar(65533) NULL COMMENT "",
  `book_id` varchar(65533) NULL COMMENT "",
  `chapter_id` varchar(65533) NULL COMMENT "",
  `mt` int(11) NULL COMMENT "",
  `corever` int(11) NULL COMMENT "",
  `user_tp` int(11) NULL COMMENT "",
  `source_user_tp` int(11) NULL COMMENT "",
  `source` varchar(65533) NULL COMMENT "",
  `lang_id` int(11) NULL COMMENT "",
  `ub_key` varchar(65533) NULL COMMENT "",
  `fst_read_tm` datetime NULL COMMENT "",
  `h12_time` datetime NULL COMMENT "",
  `h24_time` datetime NULL COMMENT "",
  `d3_time` datetime NULL COMMENT "",
  `d7_time` datetime NULL COMMENT "",
  `d30_time` datetime NULL COMMENT "",
  `tps` int(11) NULL COMMENT "",
  `types` int(11) NULL COMMENT "",
  `amt` decimal(18, 2) NULL COMMENT "",
  `create_time` datetime NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`, `user_id`, `book_id`, `chapter_id`)
DISTRIBUTED BY HASH(`user_id`, `book_id`)
PROPERTIES (
"replication_num" = "1",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
