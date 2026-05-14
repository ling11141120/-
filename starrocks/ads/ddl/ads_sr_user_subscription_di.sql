CREATE TABLE `ads_sr_user_subscription_di` (
  `dt` date NOT NULL COMMENT "统计日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `order_id` varchar(1000) NULL COMMENT "订单id",
  `create_time` datetime NULL COMMENT "订阅时间",
  `vip_expire_time` datetime NULL COMMENT "订阅到期时间",
  `shop_item_id` varchar(100) NULL COMMENT "订阅类型",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "用户最后一次订阅信息"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);