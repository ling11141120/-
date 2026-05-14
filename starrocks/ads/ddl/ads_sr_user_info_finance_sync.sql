CREATE TABLE `ads_sr_user_info_finance_sync` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `email` varchar(255) NULL COMMENT "邮箱",
  `reg_time` datetime NULL COMMENT "注册时间",
  `last_login_time` datetime NULL COMMENT "最后登录时间",
  `ip` varchar(255) NULL COMMENT "注册ip",
  `source_chl` varchar(255) NULL COMMENT "注册渠道",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "海阅-用户信息表"
DISTRIBUTED BY HASH(`dt`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);