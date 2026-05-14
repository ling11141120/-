CREATE TABLE `alg_short_video_series_list` (
  `series_id` varchar(255) NOT NULL COMMENT "剧id",
  `type` int(11) NOT NULL COMMENT "类型（0译制剧、1本土剧）",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `price` decimal(12, 2) NULL COMMENT "花费",
  `rank` int(11) NULL COMMENT "语言+类型正序"
) ENGINE=OLAP 
PRIMARY KEY(`series_id`, `type`, `language_id`)
DISTRIBUTED BY HASH(`series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);