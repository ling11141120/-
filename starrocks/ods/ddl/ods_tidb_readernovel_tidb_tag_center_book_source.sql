CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_book_source` (
  `BookId` bigint(20) NOT NULL COMMENT "书籍id",
  `LangId` int(11) NOT NULL COMMENT "语言id",
  `BookName` varchar(300) NOT NULL COMMENT "书籍名称",
  `BookNo` bigint(20) NOT NULL COMMENT "书籍代号",
  `AuthorId` bigint(20) NOT NULL COMMENT "作者id",
  `AuthorName` varchar(300) NOT NULL COMMENT "作者名称",
  `BookNature` tinyint(4) NOT NULL COMMENT "书籍类型 1机翻、2人工、3原创、4cp、5原创拆章、6翻译拆章、7原创图书、8定制文转繁体、9Cp翻译",
  `Channel` int(11) NOT NULL COMMENT "频道 1女频、2男频、9图书、0其他 ",
  `CId` int(11) NOT NULL COMMENT "分类Id",
  `CName` varchar(300) NULL COMMENT "分类名称",
  `TotalLength` int(11) NOT NULL COMMENT "总字数",
  `ChapterCount` int(11) NOT NULL COMMENT "章节数",
  `VipChapterCount` int(11) NOT NULL COMMENT "vip章节数",
  `PublishChapterCount` int(11) NOT NULL COMMENT "发布章节数",
  `PricePerThousand` int(11) NOT NULL COMMENT "千字价",
  `IsFull` int(11) NOT NULL COMMENT "是否完本",
  `IsPutaway` int(11) NOT NULL COMMENT "是否上架 0：下架，1：上架",
  `Score` int(11) NOT NULL COMMENT "评价 1:S ,2:A,3:B,4:C ",
  `IsMutex` tinyint(4) NOT NULL COMMENT "是否互斥书 0:不是，1:是",
  `ReadCount` int(11) NOT NULL COMMENT "阅读数",
  `SignType` int(11) NOT NULL COMMENT "签约类型  -1未签约、0独家、2非独家、3解约",
  `ImgSrc` varchar(950) NULL COMMENT "封面",
  `Introduce` varchar(65533) NULL COMMENT "简介",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `TagIds` varchar(1500) NULL COMMENT "tag书籍类型",
  `FreeChapterNum` int(11) NOT NULL DEFAULT "0" COMMENT "免费章节数",
  `IsBookStore` tinyint(4) NOT NULL DEFAULT "0" COMMENT "是否书库 1 是，0 不是",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `TotalPublishLength` int(11) NOT NULL DEFAULT "0" COMMENT "书籍总发布字数",
  `RealTimeScore` int(11) NULL COMMENT "实时评级",
  `RealTimeScoreTime` datetime NULL COMMENT "实时评级时间",
  `RealTimeScoreNum` decimal(18, 2) NULL COMMENT "实时评级分数",
  `SiteId` int(11) NOT NULL DEFAULT "0" COMMENT "渠道商Id",
  `Sexy2` int(11) NOT NULL DEFAULT "0" COMMENT "涉黄等级",
  `SpeedChapterNum` int(11) NOT NULL DEFAULT "0" COMMENT "超点章节数",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`BookId`, `LangId`)
COMMENT "tag后台书籍信息表"
DISTRIBUTED BY HASH(`BookId`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
