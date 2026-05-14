CREATE TABLE `ads_srsv_finance_user_pay_d` (
  `dt` date NOT NULL COMMENT "分区日期",
  `project_id` varchar(50) NOT NULL COMMENT "项目",
  `mau` int(11) NULL COMMENT "日活",
  `user_cnt_1d` int(11) NULL COMMENT "次天留存人数",
  `user_cnt_7d` int(11) NULL COMMENT "7天留存人数",
  `user_num` int(11) NULL COMMENT "新增注册数",
  `user_total` int(11) NULL COMMENT "累计注册数",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `project_id`)
COMMENT "财务-日维度 用户活跃统计+用户付费统计报表"
DISTRIBUTED BY HASH(`dt`, `project_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);