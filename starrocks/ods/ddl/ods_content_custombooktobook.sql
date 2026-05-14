CREATE TABLE `ods_content_custombooktobook` (
  `Id` int(11) NOT NULL COMMENT "自增主键ID",
  `BookId` bigint(20) NOT NULL COMMENT "定制文id",
  `SwBookId` int(11) NOT NULL COMMENT "爽文id",
  `ToLanguage` int(11) NOT NULL COMMENT "语言id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据生成时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "定制文--翻译成多语言书的关系表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
