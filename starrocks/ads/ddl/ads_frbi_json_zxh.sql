CREATE TABLE `ads_frbi_json_zxh` (
  `fr_json` varchar(65533) NULL COMMENT "fr json"
) ENGINE=OLAP 
DUPLICATE KEY(`fr_json`)
COMMENT "fr报表查看情况"
DISTRIBUTED BY HASH(`fr_json`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);