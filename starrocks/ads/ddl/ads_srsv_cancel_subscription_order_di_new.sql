CREATE TABLE `ads_srsv_cancel_subscription_order_di_new` (
  `dt` date NOT NULL COMMENT "统计日期",
  `order_id` varchar(65533) NOT NULL COMMENT "订单号",
  `core` int(11) NULL COMMENT "core",
  `mt` int(11) NULL COMMENT "终端",
  `current_language2` bigint(20) NULL COMMENT "注册语言",
  `country` varchar(65533) NULL COMMENT "国家",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `sub_pay_type` varchar(65533) NULL COMMENT "订阅渠道",
  `amount` decimal(16, 2) NULL COMMENT "订单金额",
  `etl_time` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `order_id`)
COMMENT "海剧海阅取消订单"
DISTRIBUTED BY HASH(`dt`, `order_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);