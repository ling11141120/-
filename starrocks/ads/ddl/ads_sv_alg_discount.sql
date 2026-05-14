CREATE TABLE `ads_sv_alg_discount` (
  `dt` date NOT NULL COMMENT "日期",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `core` int(11) NOT NULL COMMENT "core",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `cost_7day` int(11) NULL COMMENT "是否近1年有投放且在近7天渠道投放有消耗（1：有消耗，0：无消耗）",
  `max_date` date NULL COMMENT "最后投放日期",
  `cost_amount` int(11) NULL COMMENT "近1年投放消耗",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`, `core`)
COMMENT "海剧-海剧折扣算法新口径"
DISTRIBUTED BY HASH(`dt`, `series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);