CREATE TABLE `dim_sr_recharge_sdk_exclude` (
  `main_company` varchar(255) NULL COMMENT "主体公司",
  `language` varchar(255) NULL COMMENT "语言",
  `country` varchar(255) NULL COMMENT "国家",
  `order_number` varchar(255) NULL COMMENT "订单号",
  `payment_number` varchar(255) NULL COMMENT "付款单号",
  `recharge_user` varchar(255) NULL COMMENT "充值用户",
  `business_type` varchar(255) NULL COMMENT "业务类型",
  `core` varchar(255) NULL COMMENT "Core",
  `recharge_flow` bigint(20) NULL COMMENT "充值流水",
  `recharge_amount` decimal(12, 2) NULL COMMENT "充值金额",
  `recharge_channel` varchar(255) NULL COMMENT "充值渠道",
  `sub_channel` varchar(255) NULL COMMENT "子渠道",
  `create_time` datetime NULL COMMENT "创建时间",
  `arrival_time` datetime NULL COMMENT "到账时间",
  `order_type` varchar(255) NULL COMMENT "订单类型",
  `test_flag` varchar(255) NULL COMMENT "测试数据",
  `not_mobo` varchar(255) NULL COMMENT "用香港PAyPal回款订单剔除不属于Mobo部分",
  `ym` varchar(255) NULL COMMENT "月份",
  `main_company_rewrite` varchar(255) NULL COMMENT "主体公司改写成CHANGDU（HK）",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl时间"
) ENGINE=OLAP 
DUPLICATE KEY(`main_company`, `language`, `country`, `order_number`)
COMMENT "海剧-海外充值明细SDK（认收）报表"
DISTRIBUTED BY HASH(`main_company`, `language`, `country`, `order_number`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);