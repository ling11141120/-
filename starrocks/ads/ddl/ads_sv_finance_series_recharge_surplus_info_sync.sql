CREATE TABLE `ads_sv_finance_series_recharge_surplus_info_sync` (
  `aging_dt` date NOT NULL COMMENT "账龄存点日期",
  `order_dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `order_id` varchar(255) NOT NULL COMMENT "订单id",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `coo_order_id` varchar(255) NULL COMMENT "coo_订单id",
  `shop_item_id` varchar(50) NULL COMMENT "商品id",
  `amount` decimal(12, 2) NULL COMMENT "花费金额(观看币)",
  `surplus` decimal(12, 2) NULL COMMENT "结余",
  `cost` decimal(12, 2) NULL COMMENT "流水金额",
  `test_flag` int(11) NULL COMMENT "测试标识（0非测试，1测试）",
  `order_time` datetime NULL COMMENT "订单时间",
  `expiration_time` datetime NULL COMMENT "到期时间",
  `duration_time` int(11) NULL COMMENT "订单持续时间(到期时间-订单时间)",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`aging_dt`, `order_dt`, `product_id`, `order_id`)
COMMENT "财务-短剧用户进销存-充值结余"
DISTRIBUTED BY HASH(`aging_dt`, `order_dt`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);