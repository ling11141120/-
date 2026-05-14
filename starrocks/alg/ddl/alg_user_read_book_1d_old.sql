CREATE TABLE `alg_user_read_book_1d_old` (
  `dt` date NULL COMMENT "",
  `book_id` varchar(1048576) NULL COMMENT "",
  `user_id` varchar(1048576) NULL COMMENT "",
  `start_read_chpts` bigint(20) NOT NULL COMMENT "",
  `end_read_chpts` bigint(20) NOT NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `book_id`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 16 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);