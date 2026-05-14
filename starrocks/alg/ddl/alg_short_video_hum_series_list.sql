CREATE TABLE `alg_short_video_hum_series_list` (
  `series_id` varchar(500) NOT NULL COMMENT "短剧id",
  `lang_id` varchar(500) NOT NULL COMMENT "语言id",
  `type` varchar(500) NOT NULL COMMENT "",
  `weight` varchar(500) NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`series_id`, `lang_id`, `type`)
DISTRIBUTED BY HASH(`series_id`, `lang_id`, `type`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);