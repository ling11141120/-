CREATE TABLE `ads_sr_user_recharge_paychannel` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `pay_channel_id` array<int(11)> NULL COMMENT "支付渠道id汇总",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "阅读线-用户充值支付名称-应用于人群包数据"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 6 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);