CREATE TABLE `ads_sv_alg_discount_special` (
  `dt` date NOT NULL COMMENT "日期",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `core` int(11) NOT NULL COMMENT "core",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `max_date` date NULL COMMENT "最后投放日期",
  `rn` int(11) NULL COMMENT "top n",
  `cost_amount` int(11) NULL COMMENT "近14天花费",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`, `core`)
COMMENT "海剧-海剧折扣算法新口径-特殊算法"
DISTRIBUTED BY HASH(`dt`, `series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);