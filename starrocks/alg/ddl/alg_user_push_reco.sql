CREATE TABLE `alg_user_push_reco` (
  `user_id` varchar(500) NOT NULL COMMENT "用户id",
  `language_id` varchar(500) NOT NULL COMMENT "语言id",
  `reco_list` varchar(2000) NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `language_id`)
DISTRIBUTED BY HASH(`user_id`, `language_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);