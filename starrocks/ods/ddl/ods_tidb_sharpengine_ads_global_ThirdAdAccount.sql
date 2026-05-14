CREATE TABLE `ods_tidb_sharpengine_ads_global_ThirdAdAccount` (
  `Id` int(11) NOT NULL COMMENT "主键id",
  `Account` varchar(128) NULL COMMENT "投放账户ID",
  `Secret` varchar(128) NULL COMMENT " API Secret",
  `PageId` varchar(128) NULL COMMENT "页面",
  `AppId` varchar(128) NULL COMMENT "",
  `AppUrl` varchar(500) NULL COMMENT " AppUrl",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `ProductId` int(11) NULL COMMENT "产品id",
  `ProductName` varchar(128) NULL COMMENT "产品 账号名",
  `Mt` int(11) NULL COMMENT "设备",
  `Token` varchar(500) NULL COMMENT "Tiktok API Token",
  `InsId` varchar(500) NULL COMMENT "Tiktok InsId",
  `Status` int(11) NULL COMMENT "0-禁用 1-启用",
  `AutoFillAd` int(11) NULL COMMENT "自动填充 0 否 1 是",
  `UpdateStatus` int(11) NULL COMMENT "更新状态",
  `Chl` varchar(128) NULL COMMENT "渠道",
  `Core` int(11) NULL COMMENT "core",
  `FbAdRuleId` int(11) NULL COMMENT "自动关闭规则Id",
  `AdAutoActive` int(11) NULL COMMENT "",
  `StatusChangeTime` datetime NULL COMMENT "状态更新时间",
  `FbAccountType` int(11) NULL COMMENT "1表示再营销 0正常新增投放",
  `RowVersion` bigint(20) NULL COMMENT "同步数据用的",
  `SpendCap` bigint(20) NULL COMMENT "额度金额",
  `AmountSpent` bigint(20) NULL COMMENT "已经花费的金额",
  `PutProductId` int(11) NULL COMMENT "投放语言ID",
  `CurrentLanguage2` int(11) NULL COMMENT "投放语言",
  `AccountAdType` int(11) NULL COMMENT "账号广告类型",
  `ExchangeRate` double NULL COMMENT "汇率",
  `AccountChangeToRemarketingTime` datetime NULL COMMENT "设置为再营销账户的时间",
  `LastInsightInfo` varchar(2000) NULL COMMENT "最后一次抓取dailyinsight的信息",
  `SourceChl` varchar(128) NULL COMMENT "渠道值",
  `AdPlatformId` int(11) NOT NULL COMMENT "广告渠道 0-苹果 1-抖音 2-快手",
  `AccountTz` int(11) NOT NULL DEFAULT "-13" COMMENT "账号时区 -13=GMT-5默认时区|-20=GMT-12英西时区|-18=GMT-10葡语时区|-7=GMT+1亚洲时区",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "苹果和国内短剧的投放账号表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
