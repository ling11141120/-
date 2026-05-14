CREATE TABLE `ods_tidb_sr_sharpengine_pay_hk_sync_paychanel_da` (
  `Id` int(11) NOT NULL COMMENT "主键",
  `ProductId` int(11) NULL COMMENT "产品编号",
  `Provider` varchar(50) NULL COMMENT "",
  `MerchantName` varchar(65533) NULL COMMENT "渠道名",
  `MerchantId` varchar(500) NOT NULL COMMENT "",
  `MerchantKey` varchar(65533) NULL COMMENT "",
  `ActionUrl` varchar(500) NULL COMMENT "",
  `CallBackUrl` varchar(500) NULL COMMENT "",
  `FailUrl` varchar(500) NULL COMMENT "",
  `Enable` int(11) NULL COMMENT "",
  `ExtData` varchar(65533) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `NotifyUrl` varchar(1000) NULL COMMENT "",
  `SuccessUrl` varchar(1000) NULL COMMENT "",
  `HttpGetToMerchant` int(11) NULL COMMENT "",
  `RateToProduct` decimal(18, 2) NULL COMMENT "默认进账比例",
  `EnableLog` int(11) NULL COMMENT "",
  `Monitor` int(11) NULL COMMENT "",
  `RateToBaseMoney` decimal(18, 5) NULL COMMENT "",
  `Core` int(11) NULL DEFAULT "1" COMMENT "",
  `PayName` varchar(65533) NULL COMMENT "支付渠道名",
  `DefaultSubPayType` varchar(65533) NULL COMMENT "默认子渠道类型",
  `Corp` varchar(65533) NULL COMMENT "归属公司",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "充值渠道表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
