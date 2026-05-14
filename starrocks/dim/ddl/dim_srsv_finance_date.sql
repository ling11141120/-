CREATE TABLE `dim_srsv_finance_date` (
  `start_dt` date NOT NULL COMMENT "开始时间",
  `end_dt` date NOT NULL COMMENT "结束时间"
) ENGINE=OLAP 
PRIMARY KEY(`start_dt`, `end_dt`)
COMMENT "财务-当月跑数日期"
DISTRIBUTED BY HASH(`start_dt`, `end_dt`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);