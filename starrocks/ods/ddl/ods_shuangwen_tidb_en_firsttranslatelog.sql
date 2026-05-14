CREATE TABLE `ods_shuangwen_tidb_en_firsttranslatelog` (
  `ProductId` bigint(20) NOT NULL COMMENT "",
  `Id` int(11) NOT NULL COMMENT "",
  `ChapterId` int(11) NOT NULL COMMENT "",
  `AuthorId` bigint(20) NOT NULL COMMENT "",
  `RoleType` int(11) NOT NULL COMMENT "",
  `AuditAuthorId` bigint(20) NOT NULL COMMENT "",
  `AllotAuthorId` bigint(20) NOT NULL COMMENT "",
  `AllotTime` datetime NOT NULL COMMENT "",
  `FinishTime` datetime NULL COMMENT "",
  `AuditTime` datetime NULL COMMENT "",
  `FontLength` int(11) NOT NULL COMMENT "",
  `Price` decimal(18, 4) NOT NULL COMMENT "",
  `Status` int(11) NOT NULL COMMENT "",
  `IsDelete` tinyint(4) NOT NULL COMMENT "",
  `ToLanguage` int(11) NOT NULL COMMENT "",
  `ObjBookId` int(11) NOT NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`ProductId`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 14 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
