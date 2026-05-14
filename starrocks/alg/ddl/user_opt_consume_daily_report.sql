CREATE TABLE `user_opt_consume_daily_report` (
  `dt` date NOT NULL COMMENT "日期",
  `biz_name` varchar(2048) NOT NULL COMMENT "业务名称",
  `group_name` varchar(2048) NOT NULL COMMENT "分组名称",
  `total_user_count` bigint(20) NULL COMMENT "总人数",
  `cost_user_count` bigint(20) NULL COMMENT "消费人数",
  `cost_amount` decimal(38, 19) NULL COMMENT "总金额",
  `cost_rate` decimal(16, 6) NULL COMMENT "转化率",
  `arpu` decimal(16, 6) NULL COMMENT "arpu",
  `arppu` decimal(16, 6) NULL COMMENT "arppu"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `biz_name`, `group_name`)
COMMENT "消费每日效果日志"
DISTRIBUTED BY HASH(`dt`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);