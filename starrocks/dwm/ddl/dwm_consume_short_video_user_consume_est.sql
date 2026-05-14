CREATE TABLE `dwm_consume_short_video_user_consume_est` (
  `dt` date NOT NULL COMMENT "日期，create_time转化而来",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `epis_num` smallint(6) NOT NULL COMMENT "剧集序号",
  `create_time` datetime NOT NULL COMMENT "创建时间",
  `consume_type` smallint(6) NOT NULL COMMENT "消耗类型",
  `consume_value` decimal(20, 6) NULL COMMENT "消耗值",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`, `series_id`, `epis_num`, `create_time`, `consume_type`)
COMMENT "海剧消耗域用户消耗表-西五区时间"
DISTRIBUTED BY HASH(`dt`, `user_id`, `series_id`, `epis_num`, `create_time`, `consume_type`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, user_id, series_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
