CREATE TABLE `ods_shuangwen_tidb_xx_taskcenter` (
  `ProductId` bigint(20) NOT NULL COMMENT "",
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `TaskType` varchar(60) NULL COMMENT "业务类型",
  `TaskTitle` varchar(3000) NULL COMMENT "业务标题",
  `TaskContent` varchar(6000) NULL COMMENT "业务详细内容",
  `TaskUrl` varchar(600) NULL COMMENT "业务跳转链接",
  `TaskMenu` varchar(60) NULL COMMENT "业务跳转链接菜单名称",
  `Target` int(11) NULL COMMENT "业务链接跳转方式，0站内跳转，1站外跳转",
  `Status` int(11) NULL COMMENT "业务状态，0待处理，1已处理",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `OptUsers` varchar(600) NULL COMMENT "处理人，多个以,分隔",
  `OptPhones` varchar(300) NULL COMMENT "处理人手机号码，多个以,分隔",
  `ToLanguage` int(11) NULL COMMENT "语种SiteId",
  `FinishTime` datetime NULL COMMENT "",
  `ChapterType` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `AuthorId` bigint(20) NOT NULL DEFAULT "0" COMMENT "",
  `ChapterId` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `BookId` int(11) NOT NULL DEFAULT "0" COMMENT "翻译书籍id",
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
