CREATE TABLE `ods_tidb_short_video_tt_vip_subscription_payorder` (
  `id` bigint(20) NOT NULL COMMENT "",
  `account_id` bigint(20) NOT NULL COMMENT "账号id",
  `series_id` bigint(20) NULL COMMENT "购买的剧id（冗余）",
  `subscrption_id` bigint(20) NULL COMMENT "订阅id",
  `order_url` varchar(65533) NULL COMMENT "系统中订单信息页面的访问链接，用于Tiktok站内跳转订单详情页，不用传域名的部分，传path就行",
  `product_name` varchar(65533) NULL COMMENT "商品名称",
  `tier_id` varchar(65533) NULL COMMENT "商品ID（层级id）",
  `deduct_type` varchar(1000) NULL COMMENT "扣款类型，one_time-一次性，auto_renew-自动续订",
  `price` decimal(10, 4) NULL COMMENT "价格",
  `currency` varchar(100) NULL COMMENT "币种",
  `symbol` varchar(100) NULL COMMENT "单位",
  `trade_order_id` varchar(1000) NULL COMMENT "TikTok生成的订单号",
  `trade_order_status` int(11) NULL COMMENT "tiktok订单状态，初始化0 待支付1 支付成功2 退款-1 创建失败-2 支付取消-3",
  `subscription_record_id` bigint(20) NULL COMMENT "自己的订阅id",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "Tiktok vip订阅订单表"
DISTRIBUTED BY HASH(`id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"compression" = "LZ4"
);
