CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_book_information` (
  `Id` int(11) NOT NULL COMMENT "Id",
  `BookId` bigint(20) NOT NULL COMMENT "书籍Id",
  `LangId` int(11) NOT NULL COMMENT "语言",
  `Score` int(11) NOT NULL COMMENT "评级",
  `BookNo` varchar(3000) NULL COMMENT "书号",
  `Recommend` varchar(1520) NULL COMMENT "推荐语",
  `Remark` varchar(3000) NULL COMMENT "备注",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "修改时间",
  `ScoreUpdateTime` datetime NULL COMMENT "书籍评级更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
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
