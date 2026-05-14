CREATE TABLE `ads_etl_ready_log` (
  `create_time` date NOT NULL COMMENT "跑包日期",
  `total_num` bigint(20) NULL COMMENT "记录条数"
) ENGINE=OLAP 
UNIQUE KEY(`create_time`)
COMMENT "OLAP"
DISTRIBUTED BY HASH(`create_time`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);