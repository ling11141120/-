CREATE TABLE `alg_short_video_user_view_cnt` (
  `user_id` varchar(500) NOT NULL COMMENT "user_id",
  `series_id` varchar(500) NOT NULL COMMENT "短剧id",
  `lang_id` varchar(500) NULL COMMENT "语言id",
  `local_type` varchar(500) NULL COMMENT "短剧类型",
  `core` varchar(500) NULL COMMENT "corever",
  `cnt` bigint(20) NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `series_id`)
DISTRIBUTED BY HASH(`user_id`, `series_id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);