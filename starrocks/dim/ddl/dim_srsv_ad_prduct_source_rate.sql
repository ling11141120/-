CREATE TABLE `dim_srsv_ad_prduct_source_rate` (
  `product` varchar(50) NOT NULL COMMENT "项目语言",
  `source_plaform` varchar(50) NOT NULL COMMENT "媒体",
  `new_std` decimal(10, 2) NOT NULL COMMENT "新组目标",
  `old_std` decimal(10, 2) NULL COMMENT "老组目标",
  `new_r0_rate` decimal(10, 2) NULL COMMENT "新组达标权重",
  `log_num` int(11) NULL COMMENT "量级底数",
  `log_num_median` decimal(10, 2) NULL COMMENT "量级中位数",
  `exp_a` decimal(10, 2) NULL COMMENT "指数修正",
  `non_compliance_exp` decimal(10, 2) NULL COMMENT "不达标指数",
  `spend_exp` decimal(10, 2) NULL COMMENT "均花费比指数",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product`, `source_plaform`)
COMMENT "广告基建，项目媒体参数"
DISTRIBUTED BY HASH(`product`, `source_plaform`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);