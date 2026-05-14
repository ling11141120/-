CREATE TABLE `ods_tidb_sharpenginepaycenter_hk_paychanel` (
  `Id` int(11) NOT NULL COMMENT "",
  `ProductId` int(11) NULL COMMENT "",
  `Provider` varchar(50) NULL COMMENT "",
  `MerchantName` varchar(255) NULL COMMENT "",
  `MerchantId` varchar(128) NOT NULL COMMENT "",
  `MerchantKey` varchar(65533) NULL COMMENT "",
  `ActionUrl` varchar(128) NULL COMMENT "",
  `CallBackUrl` varchar(128) NULL COMMENT "",
  `FailUrl` varchar(128) NULL COMMENT "",
  `Enable` tinyint(4) NULL COMMENT "",
  `ExtData` varchar(65533) NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `NotifyUrl` varchar(255) NULL COMMENT "",
  `SuccessUrl` varchar(255) NULL COMMENT "",
  `HttpGetToMerchant` tinyint(4) NOT NULL COMMENT "",
  `RateToProduct` decimal(18, 2) NULL COMMENT "",
  `EnableLog` tinyint(4) NOT NULL COMMENT "",
  `Monitor` int(11) NOT NULL COMMENT "",
  `RateToBaseMoney` decimal(18, 5) NOT NULL COMMENT "",
  `Core` int(11) NULL COMMENT "",
  `RowVersion` bigint(20) NULL COMMENT "",
  `PayName` varchar(50) NULL COMMENT "",
  `RateCfg` varchar(65533) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "支付渠道信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
