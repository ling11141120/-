CREATE TABLE `ods_tidb_sharpengine_ads_global_TopOnAppInfo` (
  `Id` bigint(20) NOT NULL COMMENT "主键Id",
  `AppId` varchar(100) NOT NULL COMMENT "应用程序",
  `ProductId` int(11) NULL COMMENT "语言",
  `Mt` int(11) NULL COMMENT "终端类型 1 iOS 4 安卓",
  `Core` int(11) NULL COMMENT "Core",
  `AppName` varchar(128) NULL COMMENT "App名称",
  `PackageName` varchar(128) NULL COMMENT "包名",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "阅读app内广告相关：TopOn广告聚合平台App 信息表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
