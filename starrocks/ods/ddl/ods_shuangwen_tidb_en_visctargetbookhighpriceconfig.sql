CREATE TABLE `ods_shuangwen_tidb_en_visctargetbookhighpriceconfig` (
  `Id` int(11) NOT NULL COMMENT "编号",
  `BookNoSeries` varchar(765) NULL COMMENT "系列",
  `Language` varchar(765) NULL COMMENT "语种",
  `LanguageId` int(11) NOT NULL COMMENT "语言",
  `BookId` bigint(20) NULL COMMENT "书籍ID",
  `BookCode` varchar(765) NULL COMMENT "书籍代号",
  `BookName` varchar(765) NULL COMMENT "书名",
  `PenName` varchar(765) NULL COMMENT "笔名",
  `Stage` int(11) NULL COMMENT "///阶段 1-第一阶段 2-第二阶段 3-第三阶段，如果为0说明没有测试计划",
  `SignPrice` varchar(765) NULL COMMENT "签约价格",
  `BookType` int(11) NULL COMMENT "书籍类型 0新掌中 1ads第三阶段",
  `AddTime` datetime NOT NULL COMMENT "添加时间",
  `Updateime` datetime NOT NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "爆款作者/书高价汇总表,author:272516"
DISTRIBUTED BY HASH(`Id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
