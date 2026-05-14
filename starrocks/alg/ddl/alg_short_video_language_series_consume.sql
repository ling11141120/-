CREATE TABLE `alg_short_video_language_series_consume` (
  `language_id` varchar(255) NOT NULL COMMENT "语言id",
  `series_id` varchar(255) NOT NULL COMMENT "剧id",
  `price` bigint(20) NULL COMMENT "花费",
  `sort` int(11) NOT NULL COMMENT "按照语言+花费倒序排",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`language_id`, `series_id`)
COMMENT "算法-近15天各语言剧花费排名top50"
DISTRIBUTED BY HASH(`language_id`, `series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);