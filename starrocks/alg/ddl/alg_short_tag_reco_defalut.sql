CREATE TABLE `alg_short_tag_reco_defalut` (
  `language_id` varchar(65536) NULL COMMENT "",
  `reco_list` varchar(65536) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`language_id`)
DISTRIBUTED BY HASH(`language_id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "language_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);