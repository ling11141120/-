CREATE TABLE `dws_trade_user_recharge_temp_new` (
  `dt` date NULL COMMENT "",
  `product_id` int(11) NULL COMMENT "",
  `user_id` bigint(20) NULL COMMENT "",
  `Firstchargeday` date NULL COMMENT "",
  `Firstchargemoney` decimal(10, 2) NULL COMMENT "",
  `Autoid` bigint(20) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`, `user_id`)
DISTRIBUTED BY RANDOM
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
