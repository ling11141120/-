CREATE TABLE `alg_short_video_d1_user` (
  `dt` date NOT NULL COMMENT "分区",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `regdays` int(11) NULL COMMENT "留存天数"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`)
COMMENT "海剧算法-用户d1表"
DISTRIBUTED BY HASH(`dt`, `user_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);