CREATE TABLE `alg_short_video_user_profile_vector` (
  `user_id` int(11) NOT NULL COMMENT "剧id",
  `tag` varchar(255) NOT NULL COMMENT "tag名",
  `tag_index` int(11) NOT NULL COMMENT "位置",
  `weight` varchar(255) NOT NULL COMMENT "取值"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `tag`, `tag_index`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);