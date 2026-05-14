CREATE TABLE `alg_short_video_exp_group_report_v8` (
  `dt` date NOT NULL COMMENT "日期",
  `group_id` varchar(512) NOT NULL COMMENT "人群包人数",
  `group_uv` varchar(512) NULL COMMENT "人群包人数",
  `play_uv` varchar(512) NULL COMMENT "观看人数",
  `cost_uv` bigint(20) NULL COMMENT "消费人数",
  `recharge_uv` bigint(20) NULL COMMENT "充值人数",
  `play_count` bigint(20) NULL COMMENT "总观看集数",
  `unlock_count` bigint(20) NULL COMMENT "总解锁集数",
  `cost_amount` bigint(20) NULL COMMENT "总消费",
  `recharge_amount` bigint(20) NULL COMMENT "总充值",
  `play_rate` decimal(16, 6) NULL COMMENT "观看转化",
  `cost_rate` decimal(16, 6) NULL COMMENT "消费转化",
  `pay_rate` decimal(16, 6) NULL COMMENT "支付转化",
  `play_per_user` decimal(16, 6) NULL COMMENT "人均观看剧",
  `play_gather_per_user` decimal(16, 6) NULL COMMENT "人均观看集",
  `cost_per_user` decimal(16, 6) NULL COMMENT "人均消费",
  `pay_per_user` decimal(16, 6) NULL COMMENT "人均充值"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `group_id`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 14 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);