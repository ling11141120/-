CREATE TABLE `ads_sv_shoot_series_info` (
  `series_code` varchar(50) NOT NULL COMMENT "短剧代号",
  `series_name` varchar(255) NOT NULL COMMENT "短剧名称",
  `source` varchar(50) NOT NULL COMMENT "来源",
  `shooting_cost_usd` decimal(12, 2) NOT NULL COMMENT "拍摄费用",
  `completion_date` date NOT NULL COMMENT "拍摄完成日期",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`series_code`)
COMMENT "拍摄短剧明细-财务导入"
DISTRIBUTED BY HASH(`series_code`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);