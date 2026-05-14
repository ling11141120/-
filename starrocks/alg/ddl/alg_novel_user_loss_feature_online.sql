CREATE TABLE `alg_novel_user_loss_feature_online` (
  `user_id` varchar(1048576) NULL COMMENT "",
  `'lossfeat'` varchar(1048576) NOT NULL COMMENT "",
  `features` varchar(1048576) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`user_id`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 16 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);