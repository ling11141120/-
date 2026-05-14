CREATE TABLE `alg_short_video_user_like_default` (
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `type` int(11) NOT NULL COMMENT "类型（0译制剧、1本土剧）",
  `series_id` varchar(255) NOT NULL COMMENT "剧id",
  `weight` int(11) NOT NULL COMMENT "权重"
) ENGINE=OLAP 
PRIMARY KEY(`language_id`, `type`, `series_id`)
DISTRIBUTED BY HASH(`series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);