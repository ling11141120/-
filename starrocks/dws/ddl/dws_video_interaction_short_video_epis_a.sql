CREATE TABLE `dws_video_interaction_short_video_epis_a` (
  `dt` date NOT NULL COMMENT "统计日期，昨日",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `epis_num` smallint(6) NOT NULL COMMENT "剧集序号",
  `watch_user_bitmap` bitmap NULL COMMENT "累计观看用户bitmap",
  `watch_cnt` bigint(20) NULL COMMENT "累计剧集有效观看数据(一次观看开始、结束各产生一条，计算次数需要除以2并上浮取整,值会有误差)",
  `is_like_user_bitmap` bitmap NULL COMMENT "点赞用户bitmap",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`, `epis_num`)
COMMENT "海外短剧短剧域互动域剧集粒度观看点赞汇总表"
DISTRIBUTED BY HASH(`dt`, `series_id`, `epis_num`) BUCKETS 3 
PROPERTIES (
"replication_num" = "2",
"bloom_filter_columns" = "dt, epis_num, series_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
