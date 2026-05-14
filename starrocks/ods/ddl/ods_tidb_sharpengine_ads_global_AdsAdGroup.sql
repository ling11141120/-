CREATE TABLE `ods_tidb_sharpengine_ads_global_AdsAdGroup` (
  `Id` int(11) NOT NULL COMMENT "自增id",
  `CampId` varchar(384) NOT NULL COMMENT "广告组配置id",
  `CampaignName` varchar(384) NOT NULL COMMENT "广告组配置名称",
  `AdGroupId` varchar(384) NOT NULL COMMENT "广告id（adid)",
  `BaseAdGroupId` varchar(384) NOT NULL COMMENT "基础广告组id",
  `AdGroupName` varchar(384) NOT NULL COMMENT "广告组名称",
  `AdGroupType` varchar(384) NOT NULL COMMENT "广告组类型",
  `Settings` varchar(65533) NULL COMMENT "设置",
  `CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `Account` varchar(384) NULL COMMENT "账号",
  `Status` varchar(384) NULL COMMENT "状态",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "谷歌投放广告id记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AdGroupId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
