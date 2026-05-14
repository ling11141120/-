CREATE TABLE `alg_firstpay_feature_export` (
  `dd` varchar(1048576) NULL COMMENT "",
  `ff` varchar(1048576) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dd`)
DISTRIBUTED BY HASH(`dd`) BUCKETS 16 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);