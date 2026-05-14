CREATE TABLE `ads_sv_pay_order_notify` (
  `order_id` varchar(500) NOT NULL COMMENT "可能的订单号",
  `create_time` datetime NULL COMMENT "创建时间",
  `sku` varchar(500) NULL COMMENT "品类",
  `package_id` varchar(500) NULL COMMENT "包Id",
  `pay_type` varchar(500) NULL COMMENT "支付类型,appstore,googleplay",
  `order_type` int(11) NULL COMMENT "订单类型,订阅1/普通订单2",
  `user_id` bigint(20) NULL COMMENT "可能的用户Id",
  `product_id` int(11) NULL COMMENT "产品id",
  `notify_type` int(11) NULL COMMENT "通知的类型,对应的苹果谷歌的NotifyType（续订：1，取消：3）",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`order_id`)
COMMENT "订单通知表,主要是处理订单取消订阅"
DISTRIBUTED BY HASH(`order_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "order_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);