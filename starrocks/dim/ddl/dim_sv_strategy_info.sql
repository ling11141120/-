CREATE TABLE `dim_sv_strategy_info` (
  `id` bigint(20) NOT NULL COMMENT "策略id",
  `strategy_name` varchar(1000) NULL COMMENT "策略名称",
  `strategy_code` varchar(1000) NULL COMMENT "策略代号",
  `sort` int(11) NULL COMMENT "排序",
  `sort_popup` int(11) NULL COMMENT "",
  `sort_return` int(11) NULL COMMENT "",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "海剧，策略信息"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);