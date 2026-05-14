CREATE TABLE `ads_rough_sort_condition` (
  `type` int(11) NOT NULL COMMENT "",
  `name_cn` varchar(255) NOT NULL COMMENT "",
  `name` varchar(255) NOT NULL COMMENT "",
  `value` varchar(255) NULL COMMENT "",
  `min` decimal(18, 2) NULL COMMENT "",
  `max` decimal(18, 2) NULL COMMENT "",
  `info` varchar(255) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`type`)
COMMENT "粗分条件"
DISTRIBUTED BY HASH(`type`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);