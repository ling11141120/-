CREATE TABLE `dwd_sr_user_subscribe_expire_time` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `vip_expire_time` date NULL COMMENT "vip到期日期",
  `svip_expire_time` date NULL COMMENT "vip到期日期",
  `sign_expire_time` date NULL COMMENT "vip到期日期",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "海阅用户订阅到期表(海阅人群包专用，签到卡失效日期<t-1)"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 6 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);