CREATE TABLE `alg_short_video_series_cost_rank` (
  `dt` date NOT NULL COMMENT "统计日期（西五区）",
  `time_type` int(11) NOT NULL COMMENT "时间窗口类型（1、历史所有花费，2、近七天花费）",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `type` int(11) NOT NULL COMMENT "类型（0译制剧、1本土剧）",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `core` int(11) NOT NULL COMMENT "core",
  `series_name` varchar(1000) NOT NULL COMMENT "剧名称",
  `description` varchar(30000) NULL COMMENT "简介",
  `series_type_id` varchar(500) NULL COMMENT "短剧标签id",
  `series_type_name` varchar(500) NULL COMMENT "短剧标签",
  `price` decimal(12, 2) NULL COMMENT "花费"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `time_type`, `series_id`, `type`, `language_id`, `core`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);