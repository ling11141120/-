CREATE TABLE `ads_ir_rate_cnt_lw` (
  `ir_rate` decimal(12, 2) NULL COMMENT "",
  `cnt` int(11) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`ir_rate`, `cnt`)
COMMENT "ir_rate"
DISTRIBUTED BY HASH(`ir_rate`, `cnt`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);