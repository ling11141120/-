CREATE TABLE `alg_short_video_tag2item` (
  `tag_id` varchar(65536) NULL COMMENT "",
  `language_id` varchar(65536) NULL COMMENT "",
  `reco_list` varchar(65536) NULL COMMENT "",
  `reco_num` varchar(65536) NULL COMMENT "",
  `tag_name` varchar(65536) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`tag_id`, `language_id`)
DISTRIBUTED BY HASH(`language_id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "tag_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);