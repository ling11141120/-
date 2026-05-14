CREATE TABLE `tmp_koc_attribution_step02_active_user` (
  `product_id` int(11) NULL COMMENT "",
  `dt` date NULL COMMENT "",
  `ad_id` varchar(65533) NULL COMMENT "",
  `is_new_user` tinyint(4) NULL COMMENT "",
  `reg_country` varchar(1048576) NULL COMMENT "",
  `dev_unt` bigint(20) NOT NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`product_id`, `dt`, `ad_id`)
DISTRIBUTED BY RANDOM
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
