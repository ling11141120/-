CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdAccountAgent` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `Name` varchar(500) NULL COMMENT "",
  `CreatedTime` datetime NULL COMMENT "创建时间",
  `UpdatedTime` datetime NULL COMMENT "更新时间",
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
