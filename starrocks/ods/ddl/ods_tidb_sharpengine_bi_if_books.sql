CREATE TABLE `ods_tidb_sharpengine_bi_if_books` (
  `id` bigint(20) NOT NULL COMMENT "",
  `productid` int(11) NULL DEFAULT "0" COMMENT "",
  `bookid` bigint(20) NULL DEFAULT "1" COMMENT "",
  `newcid` int(11) NULL DEFAULT "0" COMMENT "",
  `bookname` varchar(128) NULL COMMENT "",
  `authorname` varchar(128) NULL COMMENT "",
  `channel` int(11) NULL DEFAULT "0" COMMENT "",
  `booknature` int(11) NULL DEFAULT "0" COMMENT "",
  `Length` int(11) NULL COMMENT "",
  `bookno` varchar(1000) NULL COMMENT "书号",
  `booknoseries` varchar(128) NULL COMMENT "书号系列",
  `SpeedChapterNum` int(11) NULL DEFAULT "0" COMMENT "超前点播章节数",
  `BookReaderPush` int(11) NULL DEFAULT "0" COMMENT "是否设置书籍推送 0=否|1=是",
  `PricePerThousandCfg` int(11) NULL DEFAULT "0" COMMENT "是否设置阶梯涨价 0=否|1=是",
  `PublishLength` int(11) NULL DEFAULT "0" COMMENT "发布字数",
  `IsFull` int(11) NULL DEFAULT "0" COMMENT "是否完本 0=否|1=是",
  `RemunerationTime` varchar(50) NULL COMMENT "首次翻译日期",
  `PublishChapterNum` int(11) NULL DEFAULT "0" COMMENT "已发布章节数",
  `IosReduceNum` int(11) NULL DEFAULT "0" COMMENT "IOS前N章降价开关 0=关闭|1=开启",
  `AndroidReduceNum` int(11) NULL DEFAULT "0" COMMENT "安卓前N章降价开关 0=关闭|1=开启",
  `FreeChapterNum` int(11) NULL DEFAULT "0" COMMENT "免费章节数配置",
  `VipChapterNo` int(11) NULL DEFAULT "0" COMMENT "首个Vip章节号",
  `BookLanguage` int(11) NULL DEFAULT "0" COMMENT "书籍语言",
  `BookLanguageCode` varchar(300) NULL COMMENT "书籍语言编码",
  `PricePerThousandCfgTag` int(11) NULL DEFAULT "0" COMMENT "是否设置阶梯涨价 0=否|1=是",
  `IosReduceNumTag` int(11) NULL DEFAULT "0" COMMENT "IOS前N章降价开关 0=关闭|1=开启",
  `AndroidReduceNumTag` int(11) NULL DEFAULT "0" COMMENT "安卓前N章降价开关 0=关闭|1=开启",
  `PlanContentType` int(11) NULL COMMENT "方案内容类型 1001=女频现言|1002=女频古言|1003=女频狼人|1004=男频|2001=女频译制|2002=女频本土|2003=男频译制|2004=男频本土",
  `newcidname` varchar(200) NULL COMMENT "分类名称",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "内容域--书籍信息表"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "bookid",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);