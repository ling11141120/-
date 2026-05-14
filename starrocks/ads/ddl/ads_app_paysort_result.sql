CREATE TABLE `ads_app_paysort_result` (
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `core` smallint(6) NOT NULL COMMENT "app、包",
  `country` varchar(65533) NOT NULL COMMENT "支付国家",
  `pay_name` varchar(65533) NOT NULL COMMENT "支付方式",
  `pay_ment_way` varchar(65533) NOT NULL COMMENT "渠道名称",
  `pay_channel` varchar(65533) NOT NULL COMMENT "渠道id",
  `pay_amt_rate_l3d` decimal(10, 4) NULL COMMENT "支付金额占比-3天",
  `pay_amt_rate_l7d` decimal(10, 4) NULL COMMENT "支付金额占比-7天",
  `pay_amt_rate_l14d` decimal(10, 4) NULL COMMENT "支付金额占比-14天",
  `pay_amt_rate_l30d` decimal(10, 4) NULL COMMENT "支付金额占比-30天",
  `pay_amt_rate_l60d` decimal(10, 4) NULL COMMENT "支付金额占比-60天",
  `pay_amt_rate_l90d` decimal(10, 4) NULL COMMENT "支付金额占比-90天",
  `pay_success_rate_l3d` decimal(10, 4) NULL COMMENT "支付成功占比-3天",
  `pay_success_rate_l7d` decimal(10, 4) NULL COMMENT "支付成功占比-7天",
  `pay_success_rate_l14d` decimal(10, 4) NULL COMMENT "支付成功占比-14天",
  `pay_success_rate_l30d` decimal(10, 4) NULL COMMENT "支付成功占比-30天",
  `pay_success_rate_l60d` decimal(10, 4) NULL COMMENT "支付成功占比-60天",
  `pay_success_rate_l90d` decimal(10, 4) NULL COMMENT "支付成功占比-90天",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `core`, `country`, `pay_name`, `pay_ment_way`, `pay_channel`)
COMMENT "支付排序項目結果表"
DISTRIBUTED BY HASH(`product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);