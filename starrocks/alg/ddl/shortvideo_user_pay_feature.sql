CREATE TABLE `shortvideo_user_pay_feature` (
  `user_id` varchar(1048576) NULL COMMENT "",
  `cache_key` varchar(1048576) NOT NULL COMMENT "",
  `features` varchar(1048576) NULL COMMENT ""
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