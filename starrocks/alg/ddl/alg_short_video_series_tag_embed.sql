CREATE TABLE `alg_short_video_series_tag_embed` (
  `series_id` int(11) NOT NULL COMMENT "剧id",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `tag` varchar(255) NOT NULL COMMENT "tag名",
  `tag_index` int(11) NOT NULL COMMENT "位置",
  `weight` varchar(255) NOT NULL COMMENT "取值"
) ENGINE=OLAP 
PRIMARY KEY(`series_id`, `language_id`, `tag`, `tag_index`)
DISTRIBUTED BY HASH(`series_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);