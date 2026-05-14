CREATE TABLE `alg_firstpay_feature` (
  `feature_name` varchar(65533) NOT NULL COMMENT "特征名称",
  `feature_value` varchar(65533) NOT NULL COMMENT "特征值",
  `pay_total` bigint(20) NULL COMMENT "充值总额",
  `pay_max` int(11) NULL COMMENT "最大充值金额",
  `pay_min` int(11) NULL COMMENT "最小充值金额",
  `pay_avg` decimal(38, 9) NULL COMMENT "平均充值金额",
  `pay_model` decimal(38, 9) NULL COMMENT "充值金额众数",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`feature_name`, `feature_value`)
COMMENT "算法-充值金额特征结果表"
DISTRIBUTED BY HASH(`feature_name`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);