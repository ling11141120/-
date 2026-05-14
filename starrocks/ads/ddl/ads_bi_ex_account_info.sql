CREATE TABLE `ads_bi_ex_account_info` (
  `dt` datetime NOT NULL COMMENT "注册时间",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `sex` tinyint(4) NULL COMMENT "性别",
  `mt` int(11) NULL COMMENT "终端",
  `country` varchar(255) NULL COMMENT "当前国家",
  `reg_country` varchar(255) NULL COMMENT "注册时国家",
  `app_ver` varchar(50) NULL COMMENT "app版本号",
  `ver` varchar(50) NULL COMMENT "服务端版本号",
  `corever` int(11) NULL COMMENT "包体",
  `current_language` int(11) NULL COMMENT "界面语言",
  `current_language2` int(11) NULL COMMENT "注册时语言",
  `unt` int(11) NULL COMMENT "用户数",
  `etl_tm` datetime NULL COMMENT "starrocks数据注入时间",
  INDEX index_productid (`product_id`) USING BITMAP COMMENT 'index_product_id'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "阅读-有绑定第三方账号或设置过密码的用户数"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);