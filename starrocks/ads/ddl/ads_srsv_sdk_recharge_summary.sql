CREATE TABLE `ads_srsv_sdk_recharge_summary` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `country` varchar(200) NOT NULL COMMENT "国家",
  `pay_channel` varchar(200) NOT NULL COMMENT "支付渠道",
  `if_exist` varchar(200) NOT NULL COMMENT "支付类型（普通充值、会员充值）",
  `test_flag` varchar(200) NOT NULL COMMENT "是否测试（1 测试）",
  `amount` decimal(20, 2) NULL COMMENT "充值流水",
  `base_amount` decimal(20, 2) NULL COMMENT "充值金额",
  `service_charge` decimal(20, 2) NULL COMMENT "手续费",
  `etl_time` datetime NULL COMMENT "etl处理时间",
  `recharge_cnt` bigint(20) NULL COMMENT "充值笔数"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `country`, `pay_channel`, `if_exist`, `test_flag`)
COMMENT "海剧-SDK充值汇总表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `country`, `pay_channel`, `if_exist`, `test_flag`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);