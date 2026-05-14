CREATE TABLE `ods_tidb_shuangwen_en_CustomChapterLog` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `Name` varchar(255) NOT NULL COMMENT "账户名",
  `Account` varchar(100) NOT NULL COMMENT "账户ID",
  `FontLength` int(11) NOT NULL COMMENT "章节字数",
  `LogType` int(11) NOT NULL COMMENT "日志类型（章节的创建取5：终稿） 1：正文，2：统稿，3：统稿审核，4：章纲，5：终稿,6：章纲审核",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `BookId` bigint(20) NOT NULL DEFAULT "0" COMMENT "书籍ID",
  `AddDate` int(11) NOT NULL DEFAULT "0" COMMENT "加入时间",
  `ReviewTime` datetime NULL COMMENT "检查时间",
  `RowVersion` bigint(20) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "定制文章节日志表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
