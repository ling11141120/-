CREATE TABLE `ads_sv_two_weeks_series_consume` (
  `dt` date NOT NULL COMMENT "按天统计时间分区，西五区",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `lang_id` int(11) NOT NULL COMMENT "语言id",
  `core` int(11) NOT NULL COMMENT "corever",
  `price` bigint(20) NULL COMMENT "花费",
  `sort` int(11) NOT NULL COMMENT "按照语言+花费倒序排",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`, `lang_id`, `core`)
COMMENT "海剧-近两周各语言剧花费"
DISTRIBUTED BY HASH(`dt`, `series_id`, `lang_id`, `core`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);