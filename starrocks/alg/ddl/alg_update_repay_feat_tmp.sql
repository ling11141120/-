CREATE TABLE `alg_update_repay_feat_tmp` (
  `user_id` varchar(1048576) NULL COMMENT "",
  `falg` varchar(1048576) NOT NULL COMMENT "",
  `feat_info` varchar(1048576) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`user_id`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);