CREATE TABLE `dwd_trade_sharpenginepaycenter_gporderchecklist` (
  `dt` date NOT NULL COMMENT "add_time 分区",
  `id` bigint(20) NOT NULL COMMENT "",
  `order_id` varchar(65533) NOT NULL COMMENT "",
  `order_time` datetime NULL COMMENT "",
  `app_name` varchar(65533) NULL COMMENT "",
  `order_type` varchar(65533) NULL COMMENT "订单类型",
  `order_status` varchar(65533) NULL COMMENT "订单状态",
  `order_money` varchar(65533) NULL COMMENT "订单金额，单位：元",
  `add_time` datetime NULL COMMENT "",
  `is_renew` boolean NULL COMMENT "是否续期",
  `is_losed` boolean NULL COMMENT "是否流失",
  `is_sent` boolean NULL COMMENT "是否发送",
  `sku` varchar(65533) NULL COMMENT "",
  `token` varchar(65533) NULL COMMENT "",
  `package_name` varchar(65533) NULL COMMENT "",
  `is_zero_money` boolean NULL COMMENT "是否零元购买",
  `zero_money_sent_to_server` boolean NULL COMMENT "零元购买是否已发送到服务器",
  `history_order_id` varchar(65533) NULL COMMENT "历史订单ID",
  `order_time1` datetime NULL COMMENT "",
  `order_time2` datetime NULL COMMENT "",
  `order_time3` datetime NULL COMMENT "",
  `row_version` bigint(20) NULL COMMENT "",
  `etl_time` datetime NULL COMMENT "数据etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `id`)
COMMENT "汇款中心-补单信息表"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "add_time, order_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);