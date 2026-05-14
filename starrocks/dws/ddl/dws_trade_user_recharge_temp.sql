CREATE TABLE `dws_trade_user_recharge_temp` (
  `dt` date NULL COMMENT "createtime 分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `Firstchargeday` date NULL COMMENT "首充日期",
  `Firstchargemoney` decimal(10, 2) NULL COMMENT "首充金额",
  `Autoid` bigint(20) NOT NULL COMMENT "自增id",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "用户首次充值信息表"
PARTITION BY date_trunc('day', dt)
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"partition_live_number" = "35",
"compression" = "LZ4"
);
