CREATE TABLE `ads_sv_user_cancel_subscription_di` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `order_id` varchar(1000) NULL COMMENT "订单id",
  `cancel_time` datetime NULL COMMENT "取消订阅时间",
  `shop_item_id` varchar(100) NULL COMMENT "订阅类型",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "海剧，用户最后一次取消订阅信息"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);