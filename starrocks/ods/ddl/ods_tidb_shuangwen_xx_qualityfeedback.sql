CREATE TABLE `ods_tidb_shuangwen_xx_qualityfeedback` (
  `Id` int(11) NOT NULL COMMENT "自增id",
  `FeedBackType` int(11) NOT NULL COMMENT "反馈类型",
  `SiteId` int(11) NOT NULL COMMENT "语种",
  `BookId` bigint(20) NOT NULL COMMENT "书籍id",
  `BookName` varchar(65533) NULL COMMENT "书籍名称",
  `ObjectChapterId` int(11) NOT NULL COMMENT "章节id",
  `ChapterName` varchar(65533) NULL COMMENT "章节名称",
  `ObjectCatChapterId` int(11) NULL COMMENT "句子id",
  `AuthorId` bigint(20) NOT NULL COMMENT "译员id",
  `AuthorName` varchar(65533) NULL COMMENT "译员名称",
  `RoleType` int(11) NOT NULL COMMENT "角色",
  `CompletionTime` datetime NULL COMMENT "章节完成时间",
  `Chapter` varchar(65533) NULL COMMENT "句子",
  `Sore` decimal(19, 2) NOT NULL COMMENT "分数",
  `FeedBack` varchar(65533) NULL COMMENT "反馈固定内容",
  `FeedBackOther` varchar(65533) NULL COMMENT "反馈其他内容",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `ModifyTime` datetime NULL COMMENT "修改时间",
  `CreateUserId` varchar(65533) NULL COMMENT "创建人id",
  `ModifyUserId` varchar(65533) NULL COMMENT "修改人id",
  `RowVersion` bigint(20) NULL COMMENT "数据更新版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "质量反馈表表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
