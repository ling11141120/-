CREATE TABLE `ads_sv_bi_market_statistics_order_info_di_new2` (
  `APP名称` varchar(1024) NULL COMMENT "",
  `终端` varchar(1024) NULL COMMENT "",
  `用户ID` varchar(1048576) NULL COMMENT "",
  `订单时间` datetime NULL COMMENT "",
  `充值金额` decimal(16, 2) NULL COMMENT "",
  `商品类型` varchar(1048576) NULL COMMENT "",
  `支付渠道` varchar(1024) NULL COMMENT "",
  `是否退款` varchar(1024) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`APP名称`)
DISTRIBUTED BY RANDOM
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);