CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdsAdGroup` (
  `Id` int(11) NOT NULL COMMENT "",
  `CampId` varchar(128) NULL COMMENT "",
  `CampaignName` varchar(128) NULL COMMENT "",
  `AdGroupId` varchar(128) NULL COMMENT "",
  `BaseAdGroupId` varchar(128) NULL COMMENT "",
  `AdGroupName` varchar(300) NULL COMMENT "",
  `AdGroupType` varchar(128) NULL COMMENT "",
  `Settings` varchar(65533) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `UpdateTime` datetime NULL COMMENT "",
  `Account` varchar(128) NULL COMMENT "",
  `Status` varchar(128) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
