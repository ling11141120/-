CREATE TABLE `alg_short_video_itemcf_reco_list_sqrt_top100` (
  `user_id` varchar(500) NOT NULL COMMENT "用户id",
  `language_id` varchar(500) NOT NULL COMMENT "语言id",
  `type` varchar(500) NOT NULL COMMENT "",
  `reco_list` varchar(10000) NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `language_id`, `type`)
DISTRIBUTED BY HASH(`user_id`, `language_id`, `type`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);