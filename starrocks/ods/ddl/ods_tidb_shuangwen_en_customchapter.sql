CREATE TABLE `ods_tidb_shuangwen_en_customchapter` (
  `Id` bigint(20) NOT NULL COMMENT "章节id",
  `ChapterName` varchar(255) NOT NULL COMMENT "章节名",
  `Content` varchar(65533) NULL COMMENT "终稿",
  `Status` tinyint(4) NOT NULL COMMENT "发布状态",
  `Version` int(11) NOT NULL COMMENT "当前版本",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `DelStatus` tinyint(4) NOT NULL COMMENT "删除状态",
  `Sort` int(11) NOT NULL COMMENT "章纲排序",
  `FontLength` int(11) NOT NULL COMMENT "终稿字数",
  `BookId` bigint(20) NOT NULL COMMENT "书籍id",
  `FirstDraft` varchar(65533) NULL COMMENT "初稿",
  `FinalDraft` varchar(65533) NULL COMMENT "统稿",
  `AuditStatus` tinyint(4) NULL COMMENT "审核状态",
  `FinalDraftLength` int(11) NOT NULL COMMENT "统稿字数",
  `FirstDraftLength` int(11) NOT NULL COMMENT "正文字数",
  `FirsDraftTime` datetime NULL COMMENT "正文时间",
  `FinalDraftTime` datetime NULL COMMENT "统稿时间",
  `OutlineId` bigint(20) NOT NULL COMMENT "关联章纲id",
  `FirstChapterName` varchar(255) NULL COMMENT "初稿章节名",
  `FinalChapterName` varchar(255) NULL COMMENT "统稿章节名",
  `FinalEditor` varchar(10) NULL COMMENT "统稿人",
  `FinalAudit` varchar(10) NULL COMMENT "统稿审核人",
  `OtherOutlineIds` varchar(255) NULL COMMENT "另外关联的章纲id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "定制文章节表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
