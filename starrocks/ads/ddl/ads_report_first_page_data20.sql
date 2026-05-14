CREATE TABLE `ads_report_first_page_data20` (
  `income_type` int(11) NOT NULL COMMENT "收入类型",
  `curr_month_recharge_amount` decimal(20, 4) NULL COMMENT "本月充值收入",
  `last_month_recharge_amount` decimal(20, 4) NULL COMMENT "上月充值收入",
  `curr_month_recharge_users` decimal(20, 4) NULL COMMENT "本月充值人数",
  `last_month_recharge_users` decimal(20, 4) NULL COMMENT "上月充值人数",
  `curr_month_recharge_times` decimal(20, 4) NULL COMMENT "本月充值笔数",
  `last_month_recharge_times` decimal(20, 4) NULL COMMENT "上月充值笔数",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`income_type`)
COMMENT "沙盘--首页--数据集20"
DISTRIBUTED BY HASH(`income_type`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "income_type",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);