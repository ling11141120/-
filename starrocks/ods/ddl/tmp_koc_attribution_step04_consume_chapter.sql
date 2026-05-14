CREATE TABLE `tmp_koc_attribution_step04_consume_chapter` (
  `dt` date NULL COMMENT "",
  `product_id` int(11) NULL COMMENT "",
  `ad_id` varchar(65533) NULL COMMENT "",
  `is_new_user` tinyint(4) NULL COMMENT "",
  `reg_country` varchar(1048576) NULL COMMENT "",
  `first_consume_user_num` bigint(20) NOT NULL COMMENT ""
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
