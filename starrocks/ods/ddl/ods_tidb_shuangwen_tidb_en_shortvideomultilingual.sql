CREATE TABLE `ods_tidb_shuangwen_tidb_en_shortvideomultilingual` (
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `ObjectBookType` int(11) NULL COMMENT "书籍类型，默认短剧",
  `BookCode` varchar(300) NULL COMMENT "书籍代号",
  `BookName` varchar(1000) NULL COMMENT "书籍名称",
  `ChapterNum` int(11) NULL COMMENT "章节数",
  `EnStatus` varchar(200) NULL COMMENT "英语状态",
  `SpStatus` varchar(200) NULL COMMENT "西语状态",
  `PtStatus` varchar(200) NULL COMMENT "葡语状态",
  `FrStatus` varchar(200) NULL COMMENT "法语状态",
  `RuStatus` varchar(200) NULL COMMENT "俄语状态",
  `IdStatus` varchar(200) NULL COMMENT "印尼语状态",
  `ThStatus` varchar(200) NULL COMMENT "泰语状态",
  `JpStatus` varchar(200) NULL COMMENT "日语状态",
  `KoStatus` varchar(200) NULL COMMENT "韩语状态",
  `DeStatus` varchar(200) NULL COMMENT "德语状态",
  `ItStatus` varchar(200) NULL COMMENT "意大利状态",
  `ArStatus` varchar(200) NULL COMMENT "阿拉伯状态",
  `TrStatus` varchar(200) NULL COMMENT "土耳其语状态",
  `MyStatus` varchar(200) NULL COMMENT "马来语状态",
  `TlStatus` varchar(200) NULL COMMENT "菲律宾语",
  `ViStatus` varchar(200) NULL COMMENT "越南语",
  `ModifyTime` datetime NULL COMMENT "统计更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
