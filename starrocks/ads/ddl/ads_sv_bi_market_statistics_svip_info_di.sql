CREATE TABLE `ads_sv_bi_market_statistics_svip_info_di` (
  `dt` date NOT NULL COMMENT "分区日期",
  `app_name` varchar(1024) NULL COMMENT "app名称",
  `mt` varchar(1024) NULL COMMENT "终端",
  `order_id` varchar(1024) NULL COMMENT "订单号",
  `amount` decimal(16, 2) NULL COMMENT "订阅金额",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `create_time` datetime NULL COMMENT "创建时间",
  `shop_item_id` varchar(1024) NULL COMMENT "商品id",
  `shop_item_type` varchar(1024) NULL COMMENT "商品类型",
  `vip_expire_time1` date NULL COMMENT "过期日期",
  `subscription_days` int(11) NULL COMMENT "订阅天数",
  `per_value` decimal(16, 8) NULL COMMENT "平均每天订阅价值",
  `month10_day` int(11) NULL COMMENT "10月订阅天数",
  `month10_value` decimal(16, 8) NULL COMMENT "10月订阅价值",
  `month11_day` int(11) NULL COMMENT "10月订阅天数",
  `month11_value` decimal(16, 8) NULL COMMENT "10月订阅价值",
  `month12_day` int(11) NULL COMMENT "10月订阅天数",
  `month12_value` decimal(16, 8) NULL COMMENT "10月订阅价值",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据更新时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`)
COMMENT "销售统计表KL-svip明细"
DISTRIBUTED BY HASH(`dt`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);