CREATE TABLE `ads_sv_bi_market_statistics_order_info_di_tyw_0326` (
  `充值订单号` varchar(1024) NOT NULL COMMENT "",
  `创建时间` datetime NULL COMMENT "",
  `订单完成时间` datetime NULL COMMENT "",
  `用户ID` bigint(20) NULL COMMENT "",
  `充值IP` varchar(50) NULL COMMENT "",
  `国家/地区` varchar(65533) NULL COMMENT "",
  `产品类型` varchar(1048576) NULL COMMENT "",
  `渠道` varchar(1024) NULL COMMENT "",
  `交易ID` varchar(128) NULL COMMENT "",
  `业务内定价` int(11) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`充值订单号`)
DISTRIBUTED BY RANDOM
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);