CREATE TABLE `ods_tidb_qualityfeedbackauthorsore` (
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `AuthorId` bigint(20) NOT NULL DEFAULT "0" COMMENT "译员id",
  `SiteId` int(11) NOT NULL COMMENT "站点id",
  `Sore` decimal(18, 2) NOT NULL COMMENT "分数",
  `Conetent` varchar(65533) NULL COMMENT "原文内容",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `ModifyTime` datetime NULL COMMENT "修改时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
