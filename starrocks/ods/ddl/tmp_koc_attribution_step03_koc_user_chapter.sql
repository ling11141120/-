CREATE TABLE `tmp_koc_attribution_step03_koc_user_chapter` (
  `dt` date NULL COMMENT "",
  `product_id` int(11) NULL COMMENT "",
  `ad_id` varchar(65533) NULL COMMENT "",
  `user_id` bigint(20) NULL COMMENT "",
  `is_new_user` tinyint(4) NULL COMMENT "",
  `reg_country` varchar(1048576) NULL COMMENT "",
  `book_id` bigint(20) NULL COMMENT "",
  `chapter_id` bigint(20) NULL COMMENT "",
  `chapter_num` int(11) NULL COMMENT "",
  `create_time` datetime NULL COMMENT "",
  `chapter_sign` bigint(20) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`, `ad_id`)
DISTRIBUTED BY RANDOM
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
