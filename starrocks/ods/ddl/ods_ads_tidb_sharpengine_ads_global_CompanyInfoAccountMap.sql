CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap` (
  `Id` bigint(20) NOT NULL COMMENT "ID",
  `CompanyId` int(11) NULL COMMENT "主体Id",
  `Account` varchar(128) NULL COMMENT "账号",
  `BeginTime` datetime NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `CreatedTime` datetime NULL COMMENT "创建时间",
  `UpdatedTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "账号主体关联表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
