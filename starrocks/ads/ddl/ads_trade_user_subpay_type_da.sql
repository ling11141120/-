CREATE TABLE `ads_trade_user_subpay_type_da` (
  `product_id` int(11) NOT NULL COMMENT "项目id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `sub_pay_type` varchar(65533) NULL COMMENT "支付方式",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "用户订单支付方式"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);