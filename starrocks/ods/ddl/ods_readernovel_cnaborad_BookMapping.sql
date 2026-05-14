CREATE TABLE `ods_readernovel_cnaborad_BookMapping` (
  `Id` int(11) NOT NULL COMMENT "自增Id",
  `OrginalBookId` bigint(20) NOT NULL COMMENT "原始书籍Id",
  `MappedBookId` bigint(20) NOT NULL COMMENT "映射的书籍Id",
  `BookName` varchar(765) NULL COMMENT "",
  `CloseSync` tinyint(4) NULL COMMENT "是否关闭同步",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `BookInfoMd5` varchar(765) NULL COMMENT "书籍信息Md5",
  `BookCoverETag` varchar(765) NULL COMMENT "书籍封面Md5",
  `SideBookInfoMd5` varchar(765) NULL COMMENT "二套书籍信息Md5",
  `SideBookCoverETag` varchar(765) NULL COMMENT "二套书籍封面Md5",
  `SyncTime` datetime NULL COMMENT "最后同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
