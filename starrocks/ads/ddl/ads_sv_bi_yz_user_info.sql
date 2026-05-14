CREATE TABLE `ads_sv_bi_yz_user_info` (
  `dt` date NOT NULL COMMENT "注册时间",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `create_time` datetime NULL COMMENT "注册时间",
  `reg_country` varchar(255) NULL COMMENT "国家",
  `chl2` varchar(500) NULL COMMENT "初始渠道值",
  `device_guid` varchar(500) NULL COMMENT "设备号",
  `login_tm` datetime NULL COMMENT "激活时间",
  `watch_time` datetime NULL COMMENT "首次观看时间",
  `etl_tm` datetime NOT NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "海阅-预装用户信息表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "login_tm",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);