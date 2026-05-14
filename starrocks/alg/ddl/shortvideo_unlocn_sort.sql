CREATE TABLE `shortvideo_unlocn_sort` (
  `series_id` bigint(20) NOT NULL COMMENT "",
  `uv` bigint(20) NOT NULL COMMENT "",
  `csum_uv` bigint(20) NOT NULL COMMENT "",
  `epis_cnt` bigint(20) NULL COMMENT "",
  `unlock_cnt` bigint(20) NULL COMMENT "",
  `consume_amt` bigint(20) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`series_id`, `uv`, `csum_uv`)
DISTRIBUTED BY HASH(`series_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);