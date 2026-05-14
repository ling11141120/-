CREATE TABLE `ods_tidb_sharpengine_ads_global_AdsCreationTemplateItem` (
  `Id` bigint(20) NOT NULL COMMENT "模板 ItemId",
  `TemplateId` bigint(20) NULL COMMENT "模板Id",
  `AdSetContent` varchar(65533) NULL COMMENT "广告组模板内容",
  `AdContent` varchar(65533) NULL COMMENT "广告模板内容",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `PageId` varchar(1024) NULL COMMENT "主页Id",
  `InstagramId` varchar(1024) NULL COMMENT "InstagramId",
  `AdGroupName` varchar(1024) NULL COMMENT "组别",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "创编广告组模板"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
