CREATE TABLE `ods_shuangwen_tidb_xx_ObjectChapterCheck` (
  `ProductId` bigint(20) NOT NULL COMMENT "",
  `Id` bigint(20) NOT NULL COMMENT "",
  `ChapterId` int(11) NOT NULL COMMENT "",
  `RoleType` int(11) NOT NULL COMMENT "",
  `AuthorId` bigint(20) NOT NULL COMMENT "",
  `PenName` varchar(765) NULL COMMENT "",
  `AuditAuthorId` bigint(20) NOT NULL COMMENT "",
  `AuditPenName` varchar(765) NULL COMMENT "",
  `ObjectBookId` int(11) NOT NULL COMMENT "",
  `BookId` bigint(20) NOT NULL COMMENT "",
  `ChapterName` varchar(765) NULL COMMENT "",
  `BookName` varchar(765) NULL COMMENT "",
  `Status` tinyint(4) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `UpdateTime` datetime NULL COMMENT "",
  `ToLanguage` int(11) NOT NULL COMMENT "",
  `CompletionTime` datetime NOT NULL COMMENT "",
  `DelStatus` tinyint(4) NOT NULL COMMENT "",
  `Remark` varchar(6000) NULL COMMENT "",
  `FontLength` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `FirstPercent` decimal(18, 2) NULL COMMENT "第一次修改比例",
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
