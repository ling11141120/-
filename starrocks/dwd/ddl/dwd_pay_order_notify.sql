CREATE TABLE `dwd_pay_order_notify` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `order_id` varchar(1000) NOT NULL COMMENT "订单id",
  `cancel_time` datetime NOT NULL COMMENT "取消订阅时间",
  `create_time` datetime NULL COMMENT "订单时间",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `sku` varchar(1000) NULL COMMENT "sku",
  `coo_order_id` varchar(1000) NULL COMMENT "合作支付订单号",
  `package_id` varchar(65533) NULL COMMENT "package_id",
  `pay_type` varchar(1000) NULL COMMENT "支付类型",
  `first_sub_order_serial_id` varchar(1000) NULL COMMENT "首次订阅订单号",
  `notify_type` int(11) NULL COMMENT "通知的类型,对应的苹果谷歌的NotifyType,3-取消，1-续订",
  `amount` decimal(12, 2) NULL COMMENT "支付金额",
  `base_amount` decimal(12, 2) NULL COMMENT "实付金额",
  `order_status` int(11) NULL COMMENT "订单状态",
  `shop_item_id` int(11) NULL COMMENT "订阅类型",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `order_id`, `cancel_time`)
COMMENT "取消订阅订单数据"
DISTRIBUTED BY HASH(`order_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);