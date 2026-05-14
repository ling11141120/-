CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_action_log` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `BatchId` int(11) NULL COMMENT "",
  `UserId` int(11) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `Status` tinyint(4) NULL COMMENT "",
  `ActionType` int(11) NULL COMMENT "",
  `BookId` bigint(20) NULL COMMENT "",
  `ActionId` int(11) NULL COMMENT "",
  `TitleId` int(11) NULL COMMENT "",
  `ContentId` int(11) NULL COMMENT "",
  `LangId` int(11) NULL COMMENT "",
  `ChapterId` bigint(20) NULL COMMENT "",
  `SecondLangId` int(11) NULL COMMENT "二级语言",
  `SendTime` varchar(50) NULL COMMENT "发送时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海阅"
DISTRIBUTED BY HASH(`Id`) BUCKETS 300 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
