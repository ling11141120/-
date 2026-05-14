CREATE TABLE `ods_tidb_sharpengine_ads_global_ThirdAdSet` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `AdSetId` varchar(128) NOT NULL COMMENT "广告组Id",
  `AdSetName` varchar(512) NOT NULL COMMENT "广告组名称",
  `CampaignId` varchar(128) NOT NULL COMMENT "广告系列Id",
  `Status` varchar(50) NOT NULL COMMENT "广告组状态",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `FbAccount` varchar(128) NOT NULL COMMENT "广告账号",
  `Targeting` varchar(65533) NULL COMMENT "受众对象",
  `HasActiveAdStatus` int(11) NOT NULL COMMENT "没用",
  `SourceAdSetId` varchar(128) NULL COMMENT "没用",
  `GroupAdSetId` varchar(128) NULL COMMENT "没用",
  `bid_amount` decimal(10, 2) NOT NULL COMMENT "出价",
  `daily_budget` varchar(50) NULL COMMENT "预算",
  `optimization_goal` varchar(128) NULL COMMENT "优化目标",
  `billing_event` varchar(50) NULL COMMENT "没用",
  `UpdateTime` datetime NOT NULL COMMENT "没用",
  `NotifyStatus` int(11) NOT NULL COMMENT "没用",
  `AdSetType` int(11) NOT NULL COMMENT "没用",
  `Sex` int(11) NOT NULL COMMENT "没用",
  `AdNum` int(11) NOT NULL COMMENT "没用",
  `SpendTotal` decimal(10, 2) NOT NULL COMMENT "没用",
  `AdPlatformId` int(11) NOT NULL COMMENT "广告渠道 0-苹果 1-抖音 2-快手",
  `SourceChl` varchar(128) NULL COMMENT "渠道值",
  `AdCreateTime` datetime NULL COMMENT "广告创建时间",
  `AdEndTime` datetime NULL COMMENT "修改为未投放的时间",
  `AdOptimizerCode` varchar(128) NULL COMMENT "优化师缩写",
  `TvId` varchar(128) NULL COMMENT "国剧ID",
  `TvCode` varchar(128) NULL COMMENT "国剧代号",
  `InviteCode` varchar(128) NULL COMMENT "代理商ID",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "OLAP"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AdSetId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
