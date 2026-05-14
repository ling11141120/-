CREATE TABLE `alg_short_video_user_series_info_detail` (
  `dt` date NOT NULL COMMENT "日期",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `epis_id` bigint(20) NOT NULL COMMENT "集id",
  `epis_num` smallint(6) NOT NULL COMMENT "集序号",
  `is_unlock` boolean NULL COMMENT "是否解锁",
  `is_complete` boolean NULL COMMENT "是否完整观看",
  `is_like` boolean NULL COMMENT "是否点赞",
  `coin_amt` bigint(20) NULL COMMENT "观看币消耗",
  `cert_amt` bigint(20) NULL COMMENT "观看券消耗",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`, `series_id`, `epis_id`, `epis_num`)
DISTRIBUTED BY HASH(`dt`, `user_id`, `series_id`, `epis_id`, `epis_num`) BUCKETS 420 
PROPERTIES (
"replication_num" = "2",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);