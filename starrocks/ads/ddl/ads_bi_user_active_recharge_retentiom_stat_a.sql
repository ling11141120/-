CREATE TABLE `ads_bi_user_active_recharge_retentiom_stat_a` (
  `dt` date NOT NULL COMMENT "统计日期",
  `user_type` smallint(6) NOT NULL COMMENT "用户类型:1:新用户+拉活；2：其它用户",
  `active_user_num` bigint(20) NULL COMMENT "当日活跃用户数",
  `recharge_user_num` bigint(20) NULL COMMENT "充值用户数",
  `recharge_amt` varchar(65533) NULL COMMENT "充值金额,单位：美元",
  `retention_num_2` bigint(20) NULL COMMENT "次留用户数",
  `retention_num_7` bigint(20) NULL COMMENT "7留用户数",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_type`)
COMMENT "分类型用户充值活跃留存统计表"
DISTRIBUTED BY HASH(`user_type`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);