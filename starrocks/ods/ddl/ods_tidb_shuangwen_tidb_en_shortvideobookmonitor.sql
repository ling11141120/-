CREATE TABLE `ods_tidb_shuangwen_tidb_en_shortvideobookmonitor` (
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `ObjectBookType` int(11) NOT NULL DEFAULT "1" COMMENT "书籍类型，默认短剧",
  `Level` int(11) NOT NULL DEFAULT "0" COMMENT "翻译优先级",
  `CheckStatus` int(11) NOT NULL DEFAULT "0" COMMENT "抽查状态，默认待抽查",
  `ToLanguage` int(11) NOT NULL COMMENT "语言id",
  `ObjectBookId` int(11) NOT NULL COMMENT "书籍id",
  `BookCode` varchar(450) NULL COMMENT "书籍代号",
  `BookName` varchar(1500) NULL COMMENT "书籍名称",
  `CreateTime` datetime NOT NULL COMMENT "下单创建时间",
  `BeginTime` datetime NULL COMMENT "开始翻译时间",
  `EndTime` datetime NULL COMMENT "结束翻译时间",
  `TimeTotal` double NULL COMMENT "总时长，结束时间-开始时间",
  `CheckTime` datetime NULL COMMENT "抽查完成时间",
  `ModifyTime` datetime NULL COMMENT "统计更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "翻译进度看板页面表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
