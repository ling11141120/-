CREATE TABLE `ads_sv_user_subscription` (
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `shop_item_type` varchar(100) NOT NULL COMMENT "订阅类型",
  `create_time` datetime NOT NULL COMMENT "订阅时间",
  `vip_expire_time` datetime NULL COMMENT "过期时间",
  `item_id` varchar(500) NULL COMMENT "商品id",
  `order_id` varchar(500) NULL COMMENT "订单号",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `shop_item_type`, `create_time`)
COMMENT "海剧用户订阅表"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);