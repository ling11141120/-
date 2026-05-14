CREATE TABLE `ods_tidb_readernovel_tidb_bookshelftouser` (
  `Productid` int(11) NOT NULL COMMENT "产品id",
  `ID` bigint(20) NOT NULL COMMENT "自增id",
  `UserId` bigint(20) NOT NULL COMMENT "用户id",
  `BookId` bigint(20) NOT NULL COMMENT "书籍id",
  `ChapterId` bigint(20) NOT NULL COMMENT "章节id",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `CollectTime` datetime NULL COMMENT "加入书架时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `ChapterNum` int(11) NOT NULL DEFAULT "0" COMMENT "章节数",
  `BookType` int(11) NOT NULL DEFAULT "0" COMMENT "书籍类型",
  `LastPushChapterNum` int(11) NULL COMMENT "上次推送的书籍量",
  `BookName` varchar(255) NULL COMMENT "添加时书的名称",
  `ReadType` int(11) NOT NULL COMMENT "书架书籍阅读类型",
  `ChapterIndex` bigint(20) NULL COMMENT "章节索引",
  `ReadLargestChapter` int(11) NULL COMMENT "已阅读最高章节索引",
  `LastReadTime` datetime NULL COMMENT "最后一次阅读时间",
  `LastReadChapterName` varchar(500) NULL COMMENT "最后一次阅读章节名称",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_productid (`bookid`) USING BITMAP COMMENT '书籍id索引'
) ENGINE=OLAP 
PRIMARY KEY(`Productid`, `ID`, `UserId`)
COMMENT "用户云书架记录"
DISTRIBUTED BY HASH(`Productid`, `ID`, `UserId`) BUCKETS 80 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "UserId, CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
