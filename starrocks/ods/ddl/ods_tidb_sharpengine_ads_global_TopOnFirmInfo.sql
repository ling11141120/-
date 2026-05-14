CREATE TABLE `ods_tidb_sharpengine_ads_global_TopOnFirmInfo` (
  `Id` bigint(20) NOT NULL COMMENT "主键Id",
  `FirmId` int(11) NOT NULL COMMENT "应用程序",
  `Name` varchar(128) NULL COMMENT "平台名称",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "阅读app内广告相关：TopOn广告聚合平台第三方平台 信息表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
