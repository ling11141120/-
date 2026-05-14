CREATE TABLE `alg_book_recent_icf_data` (
  `user_id` bigint(20) NULL COMMENT "",
  `books` varchar(1048576) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`user_id`, `books`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 16 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);