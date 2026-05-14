CREATE TABLE `dws_user_viedo_cn_login_ed` (
  `dt` date NOT NULL COMMENT "日期，根据CreateTime转化",
  `product_id` bigint(20) NOT NULL COMMENT "充值产品编号",
  `user_id` varchar(65533) NOT NULL COMMENT "用户Id",
  `self_type` smallint(6) NOT NULL COMMENT "自营类别 0：总；1：自营 2：分销",
  `core` int(11) NULL COMMENT "core",
  `current_language2` int(11) NULL COMMENT "当前语言",
  `mt` int(11) NULL COMMENT "设备",
  `reg_country` varchar(65533) NULL COMMENT "注册时国家",
  `reg_date` date NULL COMMENT "注册日期",
  `chl2` varchar(65533) NULL COMMENT "来源",
  `reg_days` int(11) NULL COMMENT "距离注册天数",
  `login_times` int(11) NULL COMMENT "登录次数",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `self_type`)
COMMENT "用户域国内短剧用户登录每日汇总表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
