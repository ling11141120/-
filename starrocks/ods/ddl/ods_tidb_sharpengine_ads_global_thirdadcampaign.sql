CREATE TABLE `ods_tidb_sharpengine_ads_global_thirdadcampaign` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `CampaignName` varchar(384) NOT NULL COMMENT "活动名称",
  `Status` varchar(50) NULL COMMENT "",
  `CampId` varchar(128) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `FbAccount` varchar(128) NULL COMMENT "",
  `UpdateStatus` int(11) NULL COMMENT "",
  `buying_type` varchar(128) NULL COMMENT "",
  `objective` varchar(128) NULL COMMENT "",
  `lifetime_budget` varchar(50) NULL COMMENT "",
  `daily_budget` varchar(50) NULL COMMENT "",
  `created_time` datetime NULL COMMENT "",
  `FbAdRuleId` int(11) NULL COMMENT "",
  `AdamId` varchar(128) NULL COMMENT "",
  `AdSource` varchar(50) NULL COMMENT "",
  `AdPlatformId` int(11) NULL COMMENT "广告渠道 0-苹果 1-抖音 2-快手",
  `SourceChl` varchar(128) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告项目表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
