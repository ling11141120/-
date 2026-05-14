CREATE TABLE `ads_report_user_mau_ed` (
  `years` int(11) NOT NULL COMMENT "年",
  `months` int(11) NOT NULL COMMENT "自然月",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `corever` int(11) NOT NULL COMMENT "corever",
  `current_language` int(11) NOT NULL COMMENT "当前语言",
  `current_language2` int(11) NOT NULL COMMENT "注册时语言",
  `app_ver` varchar(50) NOT NULL COMMENT "版本号",
  `mt` int(11) NOT NULL COMMENT "平台",
  `ver` varchar(50) NOT NULL COMMENT "服务端版本号",
  `reg_country` varchar(50) NOT NULL COMMENT "注册时国家",
  `user_types` int(11) NOT NULL COMMENT "用户类型 0：新用户 1：老用户",
  `user_id` bitmap NULL COMMENT "用户id",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_productid (`product_id`) USING BITMAP COMMENT '产品id索引',
  INDEX index_currentlanguage (`current_language`) USING BITMAP COMMENT '界面语言',
  INDEX index_currentlanguage2 (`current_language2`) USING BITMAP COMMENT '注册语言',
  INDEX index_months (`months`) USING BITMAP COMMENT '月',
  INDEX index_years (`years`) USING BITMAP COMMENT '年'
) ENGINE=OLAP 
PRIMARY KEY(`years`, `months`, `product_id`, `corever`, `current_language`, `current_language2`, `app_ver`, `mt`, `ver`, `reg_country`, `user_types`)
COMMENT "按月活跃用户数-区分新老用户"
DISTRIBUTED BY HASH(`months`, `product_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);