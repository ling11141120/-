CREATE TABLE `alg_short_video_user_series_predict` (
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `type` int(11) NOT NULL COMMENT "",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `cost` int(11) NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `language_id`, `type`, `series_id`)
DISTRIBUTED BY HASH(`user_id`, `language_id`, `type`, `series_id`) BUCKETS 100 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);