CREATE TABLE `ads_sv_sign_in_card_info` (
  `pay_order_id` bigint(20) NOT NULL COMMENT "订单号",
  `account_id` bigint(20) NULL COMMENT "用户id",
  `expire_time` bigint(20) NULL COMMENT "过期时间",
  `bonus` int(11) NULL COMMENT "奖励券",
  `product_id` bigint(20) NULL COMMENT "支付配置表Id",
  `goods_option_id` bigint(20) NULL COMMENT "商品价值方案ID",
  `item_id` varchar(300) NULL COMMENT "申请ID",
  `order_mark` int(11) NULL COMMENT "订单标识1正常2取消续订",
  `pay_type` int(11) NULL COMMENT "充值渠道",
  `gain_bonus` int(11) NULL COMMENT "获得的bonus",
  `gain_coin` int(11) NULL COMMENT "获得的coin",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`pay_order_id`)
COMMENT "海剧-新增签到卡会员专区及续订承接"
DISTRIBUTED BY HASH(`pay_order_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);