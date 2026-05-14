CREATE TABLE `alg_user_recharge_temp_v2` (
  `a` date NULL COMMENT "",
  `b` varchar(64) NULL COMMENT "",
  `c` bigint(20) NULL COMMENT "",
  `d` bigint(20) NULL COMMENT "",
  `e` bigint(20) NULL COMMENT "",
  `f` bigint(20) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`a`, `b`, `c`)
DISTRIBUTED BY HASH(`a`) BUCKETS 16 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);