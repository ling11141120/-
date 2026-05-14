CREATE TABLE `ads_srsv_finance_user_pay_ym` (
  `ym` varchar(50) NOT NULL COMMENT "年月",
  `project_id` varchar(50) NOT NULL COMMENT "项目",
  `mau` int(11) NULL COMMENT "月活",
  `user_num` int(11) NULL COMMENT "新增注册数",
  `user_total` int(11) NULL COMMENT "累计注册数",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`ym`, `project_id`)
COMMENT "财务-月度 用户活跃统计+用户付费统计报表"
DISTRIBUTED BY HASH(`ym`, `project_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);