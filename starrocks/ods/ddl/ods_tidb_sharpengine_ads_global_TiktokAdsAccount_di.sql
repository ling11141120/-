CREATE TABLE `ods_tidb_sharpengine_ads_global_TiktokAdsAccount_di` (
  `Id` int(11) NOT NULL COMMENT "",
  `Account` varchar(65533) NULL COMMENT "",
  `Secret` varchar(65533) NULL COMMENT "",
  `PageId` varchar(65533) NULL COMMENT "",
  `AppId` varchar(65533) NULL COMMENT "",
  `AppUrl` varchar(65533) NULL COMMENT "",
  `CreatTime` datetime NULL COMMENT "",
  `ProductId` int(11) NULL COMMENT "",
  `ProductName` varchar(65533) NULL COMMENT "",
  `Mt` int(11) NULL COMMENT "",
  `Token` varchar(65533) NULL COMMENT "",
  `InsId` varchar(65533) NULL COMMENT "",
  `Status` int(11) NULL COMMENT "",
  `AutoFillAd` int(11) NULL COMMENT "",
  `UpdateStatus` int(11) NULL COMMENT "",
  `Chl` varchar(65533) NULL COMMENT "",
  `Core` int(11) NULL COMMENT "",
  `FbAdRuleId` int(11) NULL COMMENT "",
  `AdAutoActive` int(11) NULL COMMENT "",
  `StatusChangeTime` datetime NULL COMMENT "",
  `FbAccountType` int(11) NULL COMMENT "",
  `RowVersion` bigint(20) NULL COMMENT "",
  `SpendCap` bigint(20) NULL COMMENT "",
  `AmountSpent` bigint(20) NULL COMMENT "",
  `PutProductId` int(11) NULL COMMENT "",
  `CurrentLanguage2` int(11) NULL COMMENT "",
  `AccountAdType` int(11) NULL COMMENT "",
  `ExchangeRate` decimal(18, 2) NULL COMMENT "",
  `AccountChangeToRemarketingTime` datetime NULL COMMENT "设置为再营销账户的时间",
  `LastInsightInfo` varchar(65533) NULL COMMENT "最后一次抓取dailyinsight的信息",
  `TimeZoneOffset` int(11) NULL COMMENT "相对utc的小时差",
  `AccountTz` int(11) NULL COMMENT "账号时区 -13=GMT-5默认时区|-20=GMT-12英西时区|-18=GMT-10葡语时区|-7=GMT+1亚洲时区",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "Tiktok账号表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreatTime, ProductId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
