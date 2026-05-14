CREATE TABLE `alg_short_video_user_tag_emb` (
  `user_id` int(11) NOT NULL COMMENT "用户id",
  `embedding` varchar(65533) NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`user_id`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);