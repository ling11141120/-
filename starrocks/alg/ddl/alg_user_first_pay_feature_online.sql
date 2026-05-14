CREATE TABLE `alg_user_first_pay_feature_online` (
  `feature` varchar(1048576) NULL COMMENT "",
  `feature_value` varchar(1048576) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`feature`)
DISTRIBUTED BY HASH(`feature`) BUCKETS 16 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);