CREATE TABLE `alg_short_video_itemcf_user_core_action` (
  `user_id` varchar(500) NOT NULL COMMENT "user_id",
  `series_id` varchar(500) NOT NULL COMMENT "剧id",
  `language_id` varchar(500) NOT NULL COMMENT "语言id",
  `core` int(11) NOT NULL COMMENT "corever",
  `category` varchar(500) NULL COMMENT "",
  `type` varchar(500) NULL COMMENT "",
  `weight` decimal(12, 2) NULL COMMENT "",
  `create_time` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `series_id`, `language_id`, `core`)
DISTRIBUTED BY HASH(`user_id`, `series_id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);