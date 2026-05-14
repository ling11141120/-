CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_action_title` (
  `Id` int(11) NOT NULL COMMENT "标题id",
  `LangId` int(11) NOT NULL COMMENT "语言id",
  `ActionType` int(11) NOT NULL COMMENT "活动 （ 使用 ） 类型",
  `Content` varchar(500) NOT NULL COMMENT "内容",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `Tag` varchar(500) NULL COMMENT "标签",
  `ResourceKey` varchar(765) NULL COMMENT "资源库Key",
  `Name` varchar(1500) NULL COMMENT "标题库名称",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "书城标题使用表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
