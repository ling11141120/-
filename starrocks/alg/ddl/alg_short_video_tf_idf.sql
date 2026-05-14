CREATE TABLE `alg_short_video_tf_idf` (
  `user_id` varchar(500) NOT NULL COMMENT "用户id",
  `series_id` varchar(500) NOT NULL COMMENT "剧id",
  `language_id` varchar(500) NOT NULL COMMENT "语言id",
  `type` varchar(500) NOT NULL COMMENT "",
  `core` varchar(500) NOT NULL COMMENT "",
  `free_epis` int(11) NOT NULL COMMENT "免费集数",
  `total_epis` int(11) NOT NULL COMMENT "总集数",
  `watch_epis` int(11) NOT NULL COMMENT "观看集数",
  `watch_epis_series` int(11) NOT NULL COMMENT "该剧总观看集数",
  `watch_user_num` int(11) NOT NULL COMMENT "该剧总观看人数",
  `unlock_epis` int(11) NOT NULL COMMENT "解锁集数",
  `unlock_epis_series` int(11) NOT NULL COMMENT "该剧总解锁集数",
  `unlock_user_num` int(11) NOT NULL COMMENT "该剧总解锁人数",
  `etl_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `series_id`, `language_id`, `type`, `core`)
DISTRIBUTED BY HASH(`user_id`, `series_id`, `language_id`, `type`, `core`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);