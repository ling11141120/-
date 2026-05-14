CREATE TABLE `user_read_csum_30d` (
  `book_id` varchar(65533) NULL COMMENT "",
  `read_uv` bigint(20) NOT NULL COMMENT "",
  `csum_uv` bigint(20) NOT NULL COMMENT "",
  `start_read_chpts` bigint(20) NULL COMMENT "",
  `end_read_chpts` bigint(20) NULL COMMENT "",
  `csum_total` bigint(20) NULL COMMENT "",
  `'2023-12-19'` varchar(1048576) NOT NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`book_id`)
DISTRIBUTED BY HASH(`book_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);