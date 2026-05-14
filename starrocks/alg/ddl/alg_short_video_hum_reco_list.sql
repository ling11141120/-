CREATE TABLE `alg_short_video_hum_reco_list` (
  `lang_id` varchar(500) NOT NULL COMMENT "语言id",
  `type` varchar(500) NOT NULL COMMENT "",
  `reco_list` varchar(65533) NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`lang_id`, `type`)
DISTRIBUTED BY HASH(`lang_id`, `type`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);