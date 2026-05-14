CREATE TABLE `ods_tidb_sharpengine_ads_global_AdHtml5AbTestConfigLog` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `CreateBy` varchar(1024) NULL COMMENT "创建人",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `BeforeText` varchar(1048576) NULL COMMENT "修改前数据",
  `AfterText` varchar(1048576) NULL COMMENT "修改后数据",
  `ModifyId` bigint(20) NOT NULL COMMENT "修改数据ID",
  `ModifyType` int(11) NULL COMMENT "数据类型",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "AB测配置log"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
