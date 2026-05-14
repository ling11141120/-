CREATE TABLE `ods_sr_vip_book_info` (
  `bookid` bigint(20) NOT NULL COMMENT "书籍id",
  `bookname` varchar(1024) NULL COMMENT "书名",
  `Language` int(11) NULL COMMENT "语言",
  `channelname` int(11) NULL COMMENT "频道 1女频、2男频、9图书、0其他",
  `BookNatureName` int(11) NULL COMMENT "机翻1，人工2，原创3 cp4 原创拆章5 翻译拆章6 原创图书7 定制文同步繁体8 cp翻译9",
  `Length` int(11) NOT NULL COMMENT "长度",
  `AuthorName` varchar(1024) NULL COMMENT "作者",
  `BookNo` varchar(1024) NULL COMMENT "",
  `storytype` varchar(1024) NULL COMMENT "",
  `IsFull` int(11) NULL COMMENT "是否完本",
  `Sexy2` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`bookid`)
COMMENT "海阅vip书籍"
DISTRIBUTED BY HASH(`bookid`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
