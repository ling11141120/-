CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_activity_position` (
  `Id` int(11) NOT NULL COMMENT "",
  `ActivityId` int(11) NOT NULL COMMENT "",
  `ActionType` tinyint(4) NOT NULL COMMENT "",
  `MaterialId` int(11) NOT NULL COMMENT "",
  `Url` varchar(6000) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `Status` tinyint(4) NOT NULL COMMENT "",
  `IsHide` tinyint(4) NOT NULL COMMENT "",
  `IsTop` tinyint(4) NOT NULL COMMENT "",
  `Sort` int(11) NOT NULL COMMENT "",
  `PopType` int(11) NOT NULL COMMENT "",
  `Duration` int(11) NOT NULL COMMENT "",
  `TitleId` int(11) NULL COMMENT "",
  `ContentId` int(11) NULL COMMENT "",
  `ButtonId` int(11) NULL COMMENT "",
  `RulesType` tinyint(4) NULL COMMENT "",
  `RulesValue` int(11) NULL COMMENT "",
  `GroupIds` varchar(300) NULL COMMENT "",
  `ExcludeGroupIds` varchar(300) NULL COMMENT "",
  `ExposeType` int(11) NOT NULL COMMENT "",
  `PositionName` varchar(1500) NULL COMMENT "",
  `CornerMarkId` int(11) NOT NULL COMMENT "",
  `IsFllScreen` int(11) NOT NULL COMMENT "",
  `MaterialType` tinyint(4) NOT NULL COMMENT "",
  `UseType` tinyint(4) NOT NULL COMMENT "",
  `ApplyType` int(11) NOT NULL COMMENT "应用类型",
  `JGroupIds` varchar(300) NULL COMMENT "极光人群包",
  `ExcludeJGroupIds` varchar(300) NULL COMMENT "极光剔除人群包",
  `StartChapter` int(11) NOT NULL COMMENT "起始投送章节",
  `OriginalPriceId` int(11) NOT NULL COMMENT "原价标题Id",
  `ExposeValue` int(11) NOT NULL DEFAULT "0" COMMENT "曝光类型值",
  `StrategyType` int(11) NOT NULL DEFAULT "0" COMMENT "策略类型 0实验策略，1固化策略",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "OLAP"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "ActivityId, Id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
