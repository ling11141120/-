CREATE TABLE `ads_recommended_channel_book_features_90` (
  `book_id` bigint(20) NULL COMMENT "",
  `readers_cnt` bigint(20) NULL COMMENT "",
  `chapter_cnt` bigint(20) NULL COMMENT "",
  `consume_read_chapters` bigint(20) NULL COMMENT "",
  `consume_read_readers` bigint(20) NULL COMMENT "",
  `amount_cnt` bigint(20) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`book_id`, `readers_cnt`, `chapter_cnt`)
DISTRIBUTED BY HASH(`book_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);