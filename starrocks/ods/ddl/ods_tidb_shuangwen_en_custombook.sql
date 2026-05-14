CREATE TABLE `ods_tidb_shuangwen_en_custombook` (
  `Id` bigint(20) NOT NULL COMMENT "书籍id",
  `BookName` varchar(500) NOT NULL COMMENT "书籍名称",
  `ToLanguage` int(11) NOT NULL COMMENT "语言",
  `Status` tinyint(4) NOT NULL COMMENT "状态 0:未上架，1：上架",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `DelStatus` tinyint(4) NOT NULL COMMENT "是否删除",
  `AuthorName` varchar(50) NOT NULL COMMENT "作者名称",
  `FontLength` int(11) NOT NULL COMMENT "总字数",
  `Figure` varchar(65533) NULL COMMENT "人设",
  `Outline` varchar(65533) NULL COMMENT "书籍大纲",
  `Characters` varchar(65533) NULL COMMENT "人物列表",
  `OutlineAudit` varchar(10) NULL COMMENT "章纲审核人",
  `FinalAudit` varchar(10) NULL COMMENT "统稿审核人",
  `SiteBookId` bigint(20) NOT NULL COMMENT "爽文bookid",
  `Summary` varchar(65533) NULL COMMENT "简介",
  `ChapterEditor` varchar(50) NULL COMMENT "正文编辑人",
  `OutlineEditor` varchar(50) NULL COMMENT "章纲编辑人",
  `IsSync` int(11) NOT NULL COMMENT "是否同步繁体",
  `FinalEditor` varchar(10) NULL COMMENT "统稿人",
  `BookNickName` varchar(500) NULL COMMENT "书籍别名",
  `AuthorNickName` varchar(500) NULL COMMENT "作者别名",
  `IsStatistics` int(11) NOT NULL COMMENT "是否统计，默认是",
  `UpdateType` int(11) NOT NULL COMMENT "更新状态",
  `AlertValue` int(11) NOT NULL COMMENT "翻译预警值，默认30",
  `BookCode` varchar(250) NULL COMMENT "书籍代号",
  `FreeChapterNums` varchar(250) NULL COMMENT "免费章节数量",
  `EmpowerLangIds` varchar(250) NULL COMMENT "授权语言",
  `IsDivide` tinyint(4) NULL COMMENT "是否分成",
  `Authorizer` int(11) NULL COMMENT "授权方",
  `DivideType` int(11) NULL COMMENT "分成类型0：超保底按流水分成，1：超保底按利润分成",
  `ChapterUpdateTime` datetime NULL COMMENT "章节最新更新时间",
  `ExternalBookId` bigint(20) NULL DEFAULT "0" COMMENT "外采书籍id",
  `StoryType` int(11) NULL DEFAULT "0" COMMENT "类型0长篇小说 1短篇小说",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "定制文书籍表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
