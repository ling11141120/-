CREATE TABLE `dwm_video_short_video_user_fist_time_watch` (
  `dt` date NOT NULL COMMENT "日期，create_time转化而来",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `epis_num` smallint(6) NULL COMMENT "首次观看的剧集序号",
  `create_time` datetime NULL COMMENT "创建时间-首次观看时间",
  `h12_time` datetime NULL COMMENT "首次观看时间+12h",
  `h24_time` datetime NULL COMMENT "首次观看时间+24h",
  `d7_time` datetime NULL COMMENT "首次观看时间+168h",
  `d30_time` datetime NULL COMMENT "首次观看时间+720h",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`, `series_id`)
COMMENT "短剧域用户首次观看剧粒度明细表-西五区时间"
DISTRIBUTED BY HASH(`dt`, `user_id`, `series_id`) BUCKETS 54 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, user_id, series_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
