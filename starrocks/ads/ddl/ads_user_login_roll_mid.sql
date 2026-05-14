CREATE TABLE `ads_user_login_roll_mid` (
  `product_id` int(11) NULL COMMENT "产品id",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `last_login_time` datetime MAX NULL COMMENT "最大登录时间",
  `etl_time` datetime MAX NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
AGGREGATE KEY(`product_id`, `user_id`)
COMMENT "用户末次登录记录表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);