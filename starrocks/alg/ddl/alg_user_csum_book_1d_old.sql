CREATE TABLE `alg_user_csum_book_1d_old` (
  `dt` date NULL COMMENT "",
  `user_id` varchar(1048576) NULL COMMENT "",
  `book_id` varchar(1048576) NULL COMMENT "",
  `csum_total` bigint(20) NULL COMMENT "",
  `csum_num` bigint(20) NOT NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `user_id`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 16 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);