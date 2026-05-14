CREATE TABLE `alg_short_video_series_emb` (
  `series_id` int(11) NOT NULL COMMENT "剧id",
  `language_id` varchar(255) NULL COMMENT "语言id",
  `embedding` varchar(65533) NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`series_id`)
DISTRIBUTED BY HASH(`series_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);