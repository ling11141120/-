CREATE TABLE `ads_alg_user_appnotify_verify` (
  `dt` date NOT NULL COMMENT "统计周期",
  `hour_bucket` varchar(16) NOT NULL COMMENT "执行时间段 yyyyMMddHH",
  `user_total` bigint(20) NULL COMMENT "用户总数",
  `dev_open_count` bigint(20) NULL COMMENT "设备打开数",
  `dev_close_count` bigint(20) NULL COMMENT "设备关闭数",
  `push_open_count` bigint(20) NULL COMMENT "推送打开数",
  `push_close_count` bigint(20) NULL COMMENT "推送关闭数",
  `abs_diff_open` bigint(20) NULL COMMENT "打开数差值绝对值",
  `match_open_percentage` decimal(10, 4) NULL COMMENT "打开数匹配率",
  `abs_diff_close` bigint(20) NULL COMMENT "关闭数差值绝对值",
  `match_close_percentage` decimal(10, 4) NULL COMMENT "关闭数匹配率",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `hour_bucket`)
COMMENT "算法-用户推送开关状态校验"
DISTRIBUTED BY HASH(`dt`, `hour_bucket`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);