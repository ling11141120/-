CREATE TABLE `dwd_interaction_activityparticipate` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `id` bigint(20) NOT NULL COMMENT "",
  `pid` bigint(20) NOT NULL COMMENT "",
  `type` int(11) NULL COMMENT "",
  `last_participate_tm` datetime NULL COMMENT "",
  `game_or_banner_id` bigint(20) NULL COMMENT "",
  `log_type` int(11) NULL COMMENT "",
  `click_type` int(11) NULL COMMENT "",
  `etl_tm` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `id`)
COMMENT "OLAP"
DISTRIBUTED BY HASH(`id`) BUCKETS 14 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);