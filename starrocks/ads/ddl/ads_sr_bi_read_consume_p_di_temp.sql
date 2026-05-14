CREATE TABLE `ads_sr_bi_read_consume_p_di_temp` (
  `dt` date NULL COMMENT "",
  `product_id` int(11) NULL COMMENT "",
  `user_id` bigint(20) NULL COMMENT "",
  `book_id` bigint(20) NULL COMMENT "",
  `fst_read_tm` datetime NULL COMMENT "",
  `mt` int(11) NULL COMMENT "",
  `lang_id` tinyint(4) NULL COMMENT "",
  `source_user_tp` tinyint(4) NULL COMMENT "",
  `source` varchar(1048576) NULL COMMENT "",
  `nick_name` varchar(255) NULL COMMENT "优化师名称",
  `book_name` varchar(255) NULL COMMENT "",
  `book_code` varchar(50) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`, `user_id`)
DISTRIBUTED BY RANDOM
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);