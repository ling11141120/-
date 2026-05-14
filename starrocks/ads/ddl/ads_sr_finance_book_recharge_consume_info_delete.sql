CREATE TABLE `ads_sr_finance_book_recharge_consume_info_delete` (
  `order_id` varchar(255) NOT NULL COMMENT "订单id"
) ENGINE=OLAP 
PRIMARY KEY(`order_id`)
COMMENT "财务-验证海阅数据唯一性"
DISTRIBUTED BY HASH(`order_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);