CREATE TABLE `ods_short_video_admin_center_climb_series_plan` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `LangId` int(11) NULL COMMENT "语言",
  `SeriesId` bigint(20) NULL COMMENT "剧集Id",
  `StartTime` datetime NULL COMMENT "爬榜开始时间",
  `RecommendStartTime` datetime NULL COMMENT "推荐开始时间",
  `RecommendEndTime` datetime NULL COMMENT "推荐结束时间",
  `StatisticTime` datetime NULL COMMENT "统计截止时间",
  `ListId` varchar(3000) NULL COMMENT "榜单Id,逗号分隔",
  `ClimbChartsType` int(11) NULL COMMENT "当前爬榜类型 0不爬榜，1新书榜，2榜1，3榜2",
  `NextClimbChartsType` int(11) NULL COMMENT "下一个爬榜类型 0不爬榜，1新书榜，2榜1，3榜2",
  `AdvanceType` int(11) NULL COMMENT "晋级类型 1直升晋级，2普通晋级，3延期晋级，4结束测试",
  `ReadCount` int(11) NULL COMMENT "日均阅读人数",
  `ConsumeRate` decimal(8, 4) NULL COMMENT "日均消费率",
  `UserCount` int(11) NULL COMMENT "曝光人数",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "爬榜计划"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
