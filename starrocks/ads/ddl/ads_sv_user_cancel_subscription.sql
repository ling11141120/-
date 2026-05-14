CREATE TABLE `ads_sv_user_cancel_subscription` (
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `shop_item_type` varchar(100) NOT NULL COMMENT "订阅类型",
  `cancel_time` datetime NOT NULL COMMENT "取消时间",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `shop_item_type`, `cancel_time`)
COMMENT "海剧用户取消订阅表"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);