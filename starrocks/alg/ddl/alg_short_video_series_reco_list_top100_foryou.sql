CREATE TABLE `alg_short_video_series_reco_list_top100_foryou` (
  `series_id` varchar(200) NOT NULL COMMENT "剧id",
  `reco_list` varchar(65533) NOT NULL COMMENT "推荐列表"
) ENGINE=OLAP 
PRIMARY KEY(`series_id`)
COMMENT "foryou i2i推荐结果"
DISTRIBUTED BY HASH(`series_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);