CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_book_list` (
  `Id` int(11) NOT NULL COMMENT "",
  `Name` varchar(300) NOT NULL COMMENT "榜单名称",
  `TitleId` int(11) NOT NULL COMMENT "标题Id",
  `FirstType` int(11) NOT NULL COMMENT "一级样式",
  `SecondType` varchar(30) NOT NULL COMMENT "二级样式",
  `Rows` int(11) NOT NULL COMMENT "行数",
  `Columns` int(11) NOT NULL COMMENT "列数",
  `HideRule` int(11) NOT NULL COMMENT "榜单隐藏规则",
  `HideRow` int(11) NOT NULL COMMENT "最小隐藏条数",
  `BillId` int(11) NOT NULL COMMENT "书单id",
  `ArithmeticId` int(11) NOT NULL COMMENT "算法Id",
  `ShowRule` int(11) NOT NULL COMMENT "显示规则",
  `ShowRow` int(11) NOT NULL COMMENT "滚动条数",
  `ShowMinute` int(11) NOT NULL COMMENT "显示分钟",
  `ExposureRule` int(11) NOT NULL COMMENT "曝光规则",
  `ExposureCount` int(11) NOT NULL COMMENT "曝光次数",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "修改时间",
  `ExcludeColumn` varchar(1500) NULL COMMENT "",
  `ApplyType` int(11) NOT NULL DEFAULT "1" COMMENT "应用类型",
  `FilterType` varchar(10) NULL COMMENT "过滤类型",
  `ListType` int(11) NOT NULL DEFAULT "0" COMMENT "列表进入样式（0无，1使用单本样式，2使用多本样式）",
  `SecondArithmeticId` int(11) NOT NULL DEFAULT "0" COMMENT "算法ID2",
  `SecondListNum` int(11) NULL DEFAULT "0" COMMENT "二级榜单个数",
  `ReceptPage` int(11) NOT NULL DEFAULT "1" COMMENT "0-空，1-书籍详情页，2-阅读详情页，3-阅读页（首章含简介）-串书， 4-详情页（简化版）",
  `PlanCode` varchar(300) NULL COMMENT "策略代号",
  `ClimbChartsType` int(11) NOT NULL DEFAULT "0" COMMENT "爬榜类型 0不爬榜，1新书榜，2榜1，3榜2",
  `FreeChapter` int(11) NOT NULL DEFAULT "0" COMMENT "限免章节数",
  `ClimbChartsLangId` int(11) NOT NULL DEFAULT "0" COMMENT "爬榜语言",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT ""
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
