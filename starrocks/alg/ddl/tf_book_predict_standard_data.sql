CREATE TABLE `tf_book_predict_standard_data` (
  `dt` date NULL COMMENT "",
  `mt` varchar(1048576) NULL COMMENT "",
  `book_id` varchar(1048576) NULL COMMENT "",
  `d0_base1` decimal(38, 22) NULL COMMENT "",
  `d0_base2` decimal(38, 19) NULL COMMENT "",
  `d7_base1` decimal(38, 22) NULL COMMENT "",
  `d7_base2` decimal(38, 19) NULL COMMENT "",
  `d90_base` decimal(5, 4) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `mt`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);