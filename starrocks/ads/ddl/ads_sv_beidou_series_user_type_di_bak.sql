CREATE TABLE `ads_sv_beidou_series_user_type_di_bak` (
  `dt` date NOT NULL COMMENT "日期",
  `core` int(11) NOT NULL COMMENT "Core",
  `language_code` int(11) NOT NULL COMMENT "语言编码",
  `series_id` bigint(20) NOT NULL COMMENT "短剧ID",
  `user_type` varchar(50) NOT NULL COMMENT "用户分类(订阅用户/充值用户/免费用户)",
  `country` varchar(100) NOT NULL COMMENT "国家",
  `language_name` varchar(100) NULL COMMENT "语言名称",
  `series_code` varchar(100) NULL COMMENT "短剧代号",
  `series_name` varchar(255) NULL COMMENT "短剧名称",
  `user_count` bitmap NULL COMMENT "用户数量",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `core`, `language_code`, `series_id`, `user_type`, `country`)
COMMENT "北斗短剧-用户分类统计表"
PARTITION BY date_trunc('day', dt)
DISTRIBUTED BY HASH(`dt`, `core`, `language_code`, `series_id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);