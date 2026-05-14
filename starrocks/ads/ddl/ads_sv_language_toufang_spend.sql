CREATE TABLE `ads_sv_language_toufang_spend` (
  `id` varchar(255) NOT NULL COMMENT "id（md5_key）",
  `series_id` int(11) NULL COMMENT "剧id",
  `core` int(11) NULL COMMENT "core",
  `put_language` int(11) NULL COMMENT "投放语言",
  `spend` decimal(14, 2) NULL COMMENT "投放金额",
  `spend_rate` decimal(14, 4) NULL COMMENT "投放花费占（该语言）比",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "短剧-各语言投放花费剧"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);