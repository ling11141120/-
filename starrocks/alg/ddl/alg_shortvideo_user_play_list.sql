CREATE TABLE `alg_shortvideo_user_play_list` (
  `user_id` bigint(20) NULL COMMENT "",
  `'playlist'` varchar(1048576) NOT NULL COMMENT "",
  `replace(series, ' ', '')` varchar(1048576) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`user_id`, `'playlist'`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);