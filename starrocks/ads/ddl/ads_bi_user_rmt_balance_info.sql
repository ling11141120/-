CREATE TABLE `ads_bi_user_rmt_balance_info` (
  `dt` date NOT NULL COMMENT "活跃时间",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `user_attribute` int(11) NOT NULL COMMENT "用户属性 1:svip用户,2:白嫖用户,3:普通用户",
  `bal_money_amt` int(11) NULL COMMENT "阅币余额",
  `bal_gift_amt` int(11) NULL COMMENT "礼券余额",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `user_attribute`)
COMMENT "阅读-rmt用户余额表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);