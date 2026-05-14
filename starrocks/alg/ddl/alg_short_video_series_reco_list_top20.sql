CREATE TABLE `alg_short_video_series_reco_list_top20` (
  `series_id` varchar(200) NOT NULL COMMENT "剧id",
  `reco_list` varchar(65533) NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`series_id`)
DISTRIBUTED BY HASH(`series_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);