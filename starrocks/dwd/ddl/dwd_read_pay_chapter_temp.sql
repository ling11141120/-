CREATE TABLE `dwd_read_pay_chapter_temp` (
  `book_id` bigint(20) NOT NULL COMMENT "",
  `chapter_id` bigint(20) NOT NULL COMMENT "",
  `serial_number` int(11) NULL COMMENT "",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`book_id`, `chapter_id`)
DISTRIBUTED BY HASH(`book_id`, `chapter_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);