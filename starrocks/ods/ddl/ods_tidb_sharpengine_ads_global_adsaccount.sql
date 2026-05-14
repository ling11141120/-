CREATE TABLE `ods_tidb_sharpengine_ads_global_adsaccount` (
  `Id` int(11) NOT NULL COMMENT "主键id",
  `Account` varchar(65533) NOT NULL COMMENT "谷歌投放账户ID",
  `Secret` varchar(65533) NULL COMMENT "谷歌 API Secret",
  `PageId` varchar(65533) NULL COMMENT "页面",
  `AppId` varchar(65533) NULL COMMENT "",
  `AppUrl` varchar(65533) NULL COMMENT "AppUrl",
  `CreatTime` datetime NOT NULL COMMENT "创建时间",
  `ProductId` int(11) NOT NULL COMMENT "产品id",
  `ProductName` varchar(65533) NOT NULL COMMENT "产品 账号名",
  `Mt` int(11) NULL COMMENT "设备",
  `Token` varchar(65533) NULL COMMENT "谷歌 API Token",
  `InsId` varchar(65533) NULL COMMENT "谷歌 InsId",
  `Status` int(11) NOT NULL COMMENT "0-禁用 1-启用",
  `AutoFillAd` int(11) NOT NULL COMMENT "自动填充 0 否 1 是",
  `UpdateStatus` int(11) NOT NULL COMMENT "更新状态",
  `Chl` varchar(65533) NULL COMMENT "渠道",
  `Core` int(11) NOT NULL COMMENT "core",
  `FbAdRuleId` int(11) NOT NULL COMMENT "自动关闭规则Id",
  `AdAutoActive` int(11) NOT NULL COMMENT "",
  `StatusChangeTime` datetime NOT NULL COMMENT "状态更新时间",
  `FbAccountType` int(11) NOT NULL COMMENT "1表示再营销 0正常新增投放",
  `RowVersion` bigint(20) NULL COMMENT "同步数据用的",
  `SpendCap` bigint(20) NULL DEFAULT "0" COMMENT "额度金额",
  `AmountSpent` bigint(20) NULL DEFAULT "0" COMMENT "已经花费的金额",
  `PutProductId` int(11) NOT NULL DEFAULT "0" COMMENT "投放语言ID",
  `CurrentLanguage2` int(11) NULL COMMENT "投放语言",
  `AccountAdType` int(11) NOT NULL DEFAULT "0" COMMENT "账号广告类型",
  `ExchangeRate` decimal(10, 2) NULL DEFAULT "1" COMMENT "汇率",
  `TimeZone` int(11) NOT NULL DEFAULT "24" COMMENT "时区",
  `AccountChangeToRemarketingTime` datetime NULL DEFAULT "2020-01-01 00:00:00" COMMENT "账号设置成再营销的时间",
  `LastInsightInfo` varchar(65533) NULL COMMENT "最后一次抓取dailyinsight的信息",
  `AccountTz` int(11) NOT NULL DEFAULT "-13" COMMENT "账号时区 -13=GMT-5默认时区|-20=GMT-12英西时区|-18=GMT-10葡语时区|-7=GMT+1亚洲时区",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "谷歌投放账号表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
