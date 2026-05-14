CREATE TABLE `alg_short_video_series_info_feature` (
  `series_id` varchar(255) NOT NULL COMMENT "剧id",
  `language_id` int(11) NOT NULL COMMENT "语言",
  `type` int(11) NOT NULL COMMENT "类型（0译制剧、1本土剧）",
  `country` varchar(255) NOT NULL COMMENT "国家",
  `series_name` varchar(255) NULL COMMENT "剧名",
  `description` varchar(20000) NULL COMMENT "简介",
  `price` decimal(12, 2) NULL COMMENT "花费",
  `rank` int(11) NULL COMMENT "语言+类型正序"
) ENGINE=OLAP 
PRIMARY KEY(`series_id`, `language_id`, `type`, `country`)
COMMENT "111"
DISTRIBUTED BY HASH(`series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);