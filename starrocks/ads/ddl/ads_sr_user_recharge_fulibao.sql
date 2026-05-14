CREATE TABLE `ads_sr_user_recharge_fulibao` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `recharge_cnt` int(11) NULL COMMENT "福利包次数",
  `recharge_amt` int(11) NULL COMMENT "最近一次福利包金额",
  `recharge_mode` int(11) NULL COMMENT "福利包金额众数",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "阅读线-新旧福利包指标-应用于实时人群包数据"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);