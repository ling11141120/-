CREATE TABLE `ads_push_log` (
  `timestamp` varchar(255) NOT NULL COMMENT "",
  `flag` varchar(255) NOT NULL COMMENT "",
  `corever` int(11) NULL COMMENT "",
  `user_id` int(11) NULL COMMENT "",
  `response` varchar(255) NULL COMMENT "",
  `mt` int(11) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`timestamp`)
COMMENT "海剧-push开关日志表"
DISTRIBUTED BY HASH(`timestamp`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);