CREATE TABLE `ods_tidb_selffeedbackchapter` (
  `ProductId` bigint(20) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `Type` int(11) NOT NULL DEFAULT "0" COMMENT "环节 1质检 3二校",
  `ObjectChapterId` int(11) NOT NULL COMMENT "章节id",
  `Tolanguage` int(11) NOT NULL COMMENT "语种id",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `AuthorId` bigint(20) NOT NULL COMMENT "译员id",
  `StatStatus` tinyint(4) NOT NULL COMMENT "统计状态 0无需统计 1待统计 2统计完成",
  `FontLength` int(11) NOT NULL DEFAULT "0" COMMENT "抽查翻译字数",
  `ErrorTxtNum` decimal(18, 2) NOT NULL DEFAULT "0" COMMENT "错误文本数",
  `CorrectTxtNum` decimal(18, 2) NOT NULL DEFAULT "0" COMMENT "正确文本数",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`ProductId`, `Id`)
COMMENT "抽查记录表"
DISTRIBUTED BY HASH(`ProductId`, `Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
