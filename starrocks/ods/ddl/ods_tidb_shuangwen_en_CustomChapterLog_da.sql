CREATE TABLE `ods_tidb_shuangwen_en_CustomChapterLog_da` (
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `Name` varchar(755) NOT NULL COMMENT "用户名",
  `Account` varchar(355) NOT NULL COMMENT "账号",
  `FontLength` int(11) NOT NULL COMMENT "字数",
  `LogType` int(11) NOT NULL COMMENT "日志类型 1：正文，2：统稿，3：统稿审核，4：章纲，5：终稿,6：章纲审核",
  `ChapterId` bigint(20) NOT NULL COMMENT "章节id",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `BookId` bigint(20) NOT NULL DEFAULT "0" COMMENT "书籍id",
  `AddDate` int(11) NOT NULL DEFAULT "0" COMMENT "月份",
  `ReviewTime` datetime NULL COMMENT "审核时间",
  `RowVersion` bigint(20) NULL COMMENT "没用字段",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "阅读-定制文发布到平台（编辑后台）的章节字数数据"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
