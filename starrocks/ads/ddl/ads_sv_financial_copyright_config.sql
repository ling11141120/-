CREATE TABLE `ads_sv_financial_copyright_config` (
  `copyright` varchar(100) NOT NULL COMMENT "版权方",
  `series_code` varchar(100) NOT NULL COMMENT "短剧代号",
  `privileged_date` date NOT NULL COMMENT "授权时间"
) ENGINE=OLAP 
PRIMARY KEY(`copyright`, `series_code`, `privileged_date`)
DISTRIBUTED BY HASH(`copyright`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);