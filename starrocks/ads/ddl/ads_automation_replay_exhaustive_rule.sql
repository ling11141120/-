CREATE TABLE `ads_automation_replay_exhaustive_rule` (
  `rule_id` varchar(100) NOT NULL COMMENT "rule_id",
  `product` int(11) NULL COMMENT "项目",
  `language_id` int(11) NULL COMMENT "语言",
  `source_chl` varchar(20) NULL COMMENT "来源渠道",
  `week_day_min` int(11) NULL COMMENT "",
  `week_day_max` int(11) NULL COMMENT "",
  `days_spend_min` int(11) NULL COMMENT "",
  `days_spend_max` int(11) NULL COMMENT "",
  `hours_spend_min` int(11) NULL COMMENT "",
  `hours_spend_max` int(11) NULL COMMENT "",
  `hn_spend_min` int(11) NULL COMMENT "",
  `hn_spend_max` int(11) NULL COMMENT "",
  `R0_min` decimal(12, 2) NULL COMMENT "",
  `R0_max` decimal(12, 2) NULL COMMENT "",
  `D0_CAC_min` int(11) NULL COMMENT "",
  `D0_CAC_max` int(11) NULL COMMENT "",
  `IR_rate_min` decimal(12, 2) NULL COMMENT "",
  `IR_rate_max` decimal(12, 2) NULL COMMENT "",
  `R0_bf1_min` decimal(12, 2) NULL COMMENT "",
  `R0_bf1_max` decimal(12, 2) NULL COMMENT "",
  `R0_bf2_n_min` decimal(12, 2) NULL COMMENT "",
  `R0_bf2_n_max` decimal(12, 2) NULL COMMENT "",
  `sort_id` bigint(20) NULL COMMENT "",
  `etl_time` datetime NULL COMMENT "处理时间",
  INDEX index_rule_id (`rule_id`) USING BITMAP COMMENT 'index_rule_id',
  INDEX index_language_id (`language_id`) USING BITMAP COMMENT 'index_language_id',
  INDEX index_source_chl (`source_chl`) USING BITMAP COMMENT 'index_source_chl',
  INDEX index_R0_min (`R0_min`) USING BITMAP COMMENT 'index_R0_min',
  INDEX index_days_spend_min (`days_spend_min`) USING BITMAP COMMENT 'index_days_spend_min',
  INDEX index_sort_id (`sort_id`) USING BITMAP COMMENT 'index_sort_id'
) ENGINE=OLAP 
PRIMARY KEY(`rule_id`)
COMMENT "自动化复盘-data2穷举规则"
DISTRIBUTED BY HASH(`rule_id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);