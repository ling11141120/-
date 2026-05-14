CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_MarketingPlanAutoStage` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `PlanId` bigint(20) NULL COMMENT "计划ID",
  `DateKey` varchar(500) NULL COMMENT "日期",
  `ProjectCode` int(11) NULL COMMENT "项目类型 1=海阅|2=海剧",
  `CodeId` varchar(500) NULL COMMENT "代号ProjectCode为1=书籍ID|ProjectCode为2=短剧ID",
  `CodeNameShow` varchar(500) NULL COMMENT "剧集显示名",
  `Language` int(11) NULL COMMENT "语言",
  `SourceChl` varchar(500) NULL COMMENT "媒体",
  `BeginDate` datetime NULL COMMENT "开始日期",
  `EndDate` datetime NULL COMMENT "结束日期",
  `AutoStageType` int(11) NULL COMMENT "自动进阶类型",
  `AutoBeginDate` datetime NULL COMMENT "进阶开始日期",
  `AutoCodeStage` int(11) NULL COMMENT "自动计算最高阶段投放阶段",
  `AutoBudget` decimal(14, 4) NULL COMMENT "自动计算预算",
  `AutoCodeLv` varchar(500) NULL COMMENT "自动计算等级",
  `Spend` decimal(14, 4) NULL COMMENT "当前花费/消耗",
  `R0Target` decimal(14, 4) NULL COMMENT "D0标准收入",
  `Day0Amount` decimal(14, 4) NULL COMMENT "D0 收入",
  `R0StdReach` decimal(14, 4) NULL COMMENT "D0 ROI标准阶段达标率",
  `R0StdDaysCount` int(11) NULL COMMENT "D0 标准达标天数",
  `NewNumRatio` decimal(14, 4) NULL COMMENT "纯新用户占比",
  `IsSync` int(11) NULL COMMENT "是否已同步 0=否|1=是",
  `IsDel` int(11) NULL COMMENT "删除",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `Creator` varchar(500) NULL COMMENT "创建人",
  `CreatorUid` varchar(500) NULL COMMENT "创建人账号ID",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `Updater` varchar(500) NULL COMMENT "更新人",
  `UpdaterUid` varchar(500) NULL COMMENT "更新人账号ID",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "市场测推自动阶段记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
