CREATE TABLE `ods_ad_sharpengine_ads_global_FbAdSet` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `AdSetId` varchar(500) NULL COMMENT "",
  `AdSetName` varchar(2000) NULL COMMENT "",
  `CampaignId` varchar(500) NULL COMMENT "",
  `Status` varchar(200) NULL COMMENT "",
  `FbAccount` varchar(500) NULL COMMENT "",
  `Targeting` varchar(65533) NULL COMMENT "",
  `HasActiveAdStatus` int(11) NULL COMMENT "",
  `SourceAdSetId` varchar(500) NULL COMMENT "",
  `GroupAdSetId` varchar(500) NULL COMMENT "",
  `bid_amount` int(11) NULL COMMENT "",
  `daily_budget` varchar(200) NULL COMMENT "",
  `optimization_goal` varchar(500) NULL COMMENT "",
  `billing_event` varchar(200) NULL COMMENT "",
  `NotifyStatus` int(11) NULL COMMENT "",
  `AdSetType` int(11) NULL COMMENT "",
  `Sex` int(11) NULL COMMENT "",
  `AdNum` int(11) NULL COMMENT "",
  `SpendTotal` decimal(10, 2) NULL COMMENT "",
  `RowVersion` bigint(20) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `StartTime` varchar(200) NULL COMMENT "广告组开始日期",
  `PageId` varchar(200) NULL COMMENT "Fb主页",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告组信息表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
