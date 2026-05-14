CREATE TABLE `ods_tidb_sharpengine_ads_global_TopOnPlacementInfo` (
  `Id` bigint(20) NOT NULL COMMENT "主键Id",
  `AppId` varchar(100) NOT NULL COMMENT "应用程序Id",
  `PlacementId` varchar(100) NOT NULL COMMENT "广告位Id",
  `Name` varchar(256) NULL COMMENT "广告位名称",
  `AdFormat` varchar(256) NULL COMMENT "广告样式",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "阅读app内广告相关：TopOn广告聚合平台广告位 信息表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
