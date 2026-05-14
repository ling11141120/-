CREATE TABLE `ads_report_first_page_data19` (
  `income_type` int(11) NOT NULL COMMENT "收入类型",
  `curr_season_recharge_amount` decimal(20, 4) NULL COMMENT "本季度充值收入",
  `last_season_sametime_recharge_amount` decimal(20, 4) NULL COMMENT "上季度同期充值收入",
  `curr_season_recharge_users` decimal(20, 4) NULL COMMENT "本季度充值人数",
  `last_season_sametime_recharge_users` decimal(20, 4) NULL COMMENT "上季度同期充值人数",
  `curr_season_recharge_times` decimal(20, 4) NULL COMMENT "本季度充值笔数",
  `last_season_sametime_recharge_times` decimal(20, 4) NULL COMMENT "上季度同期充值笔数",
  `last_season_recharge_amount` decimal(20, 4) NULL COMMENT "上季度充值收入",
  `last_season_recharge_users` decimal(20, 4) NULL COMMENT "上季度充值人数",
  `last_season_recharge_times` decimal(20, 4) NULL COMMENT "上季度充值笔数",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`income_type`)
COMMENT "沙盘--首页--数据集19"
DISTRIBUTED BY HASH(`income_type`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "income_type",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);