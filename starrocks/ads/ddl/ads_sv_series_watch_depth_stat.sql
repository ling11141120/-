CREATE TABLE `ads_sv_series_watch_depth_stat` (
  `dt` date NOT NULL COMMENT "日期",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `start_watch_user_cnt` bigint(20) NULL COMMENT "开始观看人数",
  `avg_watch_episode_cnt` decimal(10, 2) NULL COMMENT "人均观看集数",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`, `language_id`)
COMMENT "海剧-剧集播放深度统计表（用于算法返回推优化）"
DISTRIBUTED BY HASH(`dt`, `series_id`, `language_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);