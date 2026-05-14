CREATE TABLE `ads_sv_trade_user_recharge_info` (
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `current_language` int(11) NULL COMMENT "最新用户使用语言",
  `corever` int(11) NULL COMMENT "core",
  `last_login_time` datetime NULL COMMENT "最后登录时间",
  `expire_time` datetime NULL COMMENT "过期时间",
  `bind_email` varchar(65533) NULL COMMENT "登录绑定邮箱(bind是用户自己绑的)",
  `last_recharge_tm` datetime NULL COMMENT "最近一次充值时间",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`)
COMMENT "海剧用户充值信息"
DISTRIBUTED BY HASH(`user_id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);