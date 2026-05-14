CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_book_channel` (
  `Id` int(11) NOT NULL COMMENT "",
  `Name` varchar(100) NOT NULL COMMENT "名称",
  `TitleId` int(11) NOT NULL COMMENT "标题库Id",
  `ChannelType` int(11) NOT NULL COMMENT "频道类型",
  `RepetitionType` int(11) NOT NULL COMMENT "排重类型 1: 是 ； 2: 否",
  `CreateTime` datetime NOT NULL COMMENT "",
  `UpdateTime` datetime NOT NULL COMMENT "",
  `ApplyType` int(11) NOT NULL COMMENT "应用类型",
  `TemplateId` int(11) NOT NULL DEFAULT "0" COMMENT "模板Id",
  `PlanCode` varchar(300) NULL COMMENT "策略代号",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "书城频道表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
