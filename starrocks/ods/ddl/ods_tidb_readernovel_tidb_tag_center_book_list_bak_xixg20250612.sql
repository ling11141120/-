CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_book_list_bak_xixg20250612` (
  `Id` int(11) NOT NULL COMMENT "",
  `Name` varchar(100) NOT NULL COMMENT "榜单名称",
  `TitleId` int(11) NOT NULL COMMENT "标题Id",
  `FirstType` int(11) NOT NULL COMMENT "一级样式",
  `SecondType` varchar(10) NOT NULL COMMENT "二级样式",
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
  `ExcludeColumn` varchar(500) NULL COMMENT "",
  `ApplyType` int(11) NOT NULL COMMENT "应用类型",
  `FilterType` varchar(10) NULL COMMENT "过滤类型",
  `ListType` int(11) NOT NULL COMMENT "列表进入样式（0无，1使用单本样式，2使用多本样式）",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "书籍曝光"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
