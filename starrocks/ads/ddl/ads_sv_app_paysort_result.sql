CREATE TABLE `ads_sv_app_paysort_result` (
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `country` varchar(65533) NOT NULL COMMENT "支付国家",
  `pay_name` varchar(65533) NOT NULL COMMENT "支付方式",
  `pay_channel` varchar(65533) NOT NULL COMMENT "支付子渠道(支付id)",
  `pay_ment_way` varchar(65533) NOT NULL COMMENT "支付渠道",
  `pay_amt_l3d` decimal(20, 6) NULL COMMENT "支付金额-3天",
  `pay_amt_l7d` decimal(20, 6) NULL COMMENT "支付金额-7天",
  `pay_amt_l14d` decimal(20, 6) NULL COMMENT "支付金额-14天",
  `pay_amt_l30d` decimal(20, 6) NULL COMMENT "支付金额-30天",
  `pay_amt_l60d` decimal(20, 6) NULL COMMENT "支付金额-60天",
  `pay_amt_l90d` decimal(20, 6) NULL COMMENT "支付金额-90天",
  `pay_success_rate_l3d` decimal(20, 6) NULL COMMENT "支付成功占比-3天",
  `pay_success_rate_l7d` decimal(20, 6) NULL COMMENT "支付成功占比-7天",
  `pay_success_rate_l14d` decimal(20, 6) NULL COMMENT "支付成功占比-14天",
  `pay_success_rate_l30d` decimal(20, 6) NULL COMMENT "支付成功占比-30天",
  `pay_success_rate_l60d` decimal(20, 6) NULL COMMENT "支付成功占比-60天",
  `pay_success_rate_l90d` decimal(20, 6) NULL COMMENT "支付成功占比-90天",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `country`, `pay_name`, `pay_channel`, `pay_ment_way`)
COMMENT "海剧支付排序項目結果表"
DISTRIBUTED BY HASH(`product_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);