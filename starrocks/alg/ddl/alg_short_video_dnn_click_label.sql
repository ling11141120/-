CREATE TABLE `alg_short_video_dnn_click_label` (
  `user_id` varchar(500) NOT NULL COMMENT "user_id",
  `series_id` varchar(500) NOT NULL COMMENT "剧id",
  `language_id` varchar(500) NULL COMMENT "语言id",
  `category` varchar(500) NULL COMMENT "",
  `type` varchar(500) NULL COMMENT "",
  `label` decimal(12, 2) NULL COMMENT "",
  `dt` date NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `series_id`)
DISTRIBUTED BY HASH(`user_id`, `series_id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);