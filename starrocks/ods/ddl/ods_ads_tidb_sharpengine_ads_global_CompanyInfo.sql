CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_CompanyInfo` (
  `Id` int(11) NOT NULL COMMENT "ID",
  `CompanyName` varchar(255) NULL COMMENT "主体名称",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `CreateBy` varchar(255) NULL COMMENT "创建人",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `UpdateBy` varchar(255) NULL COMMENT "更新人",
  `AliasName` varchar(255) NULL COMMENT "主体别名",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "公司主体"
DISTRIBUTED BY HASH(`Id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
