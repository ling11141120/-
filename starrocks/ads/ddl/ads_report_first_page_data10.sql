CREATE TABLE `ads_report_first_page_data10` (
  `product_type_name` varchar(100) NOT NULL COMMENT "产品名称",
  `month2` varchar(10) NULL COMMENT "月份2",
  `recharge` bigint(20) NULL COMMENT "充值",
  `recharge_after_fencheng` bigint(20) NULL COMMENT "分成后充值",
  `promotion_expenses` decimal(20, 4) NULL COMMENT "推广费用",
  `spend_rate` decimal(20, 4) NULL COMMENT "投放比",
  `recharge_cut_promotion` decimal(20, 4) NULL COMMENT "扣除推广后充值",
  `total_recharge` decimal(20, 4) NULL COMMENT "总充值",
  `month` varchar(10) NULL COMMENT "月份",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`product_type_name`, `month2`)
COMMENT "沙盘--首页--数据集10"
DISTRIBUTED BY HASH(`product_type_name`, `month2`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "product_type_name",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);