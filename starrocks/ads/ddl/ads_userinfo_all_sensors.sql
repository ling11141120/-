CREATE TABLE `ads_userinfo_all_sensors` (
  `userid` varchar(65533) NOT NULL COMMENT "",
  `json1` json NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`userid`)
DISTRIBUTED BY HASH(`userid`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);