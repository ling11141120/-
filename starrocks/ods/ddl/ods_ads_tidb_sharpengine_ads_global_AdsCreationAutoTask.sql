CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdsCreationAutoTask` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `DateKey` varchar(255) NULL COMMENT "日期",
  `AutoTaskType` int(11) NULL COMMENT "自动任务类型 1=每日首批|2=加量",
  `ProjectCode` int(11) NULL COMMENT "项目类型 1=海阅|2=海剧",
  `CodeId` varchar(255) NULL COMMENT "代号ProjectCode为1=书籍ID|ProjectCode为2=短剧ID",
  `SourceChl` varchar(500) NULL COMMENT "媒体",
  `CurrentLanguage` int(11) NULL COMMENT "投放语言",
  `PlanId` varchar(255) NULL COMMENT "创编方案Id",
  `AssetPlanId` bigint(20) NULL COMMENT "创编素材筛选方案ID",
  `ScheduleDate` varchar(255) NULL COMMENT "排期日期",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `Creator` varchar(255) NULL COMMENT "创建人",
  `CreatorUid` varchar(255) NULL COMMENT "创建人账号ID",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `Updater` varchar(255) NULL COMMENT "更新人",
  `UpdaterUid` varchar(255) NULL COMMENT "更新人账号ID",
  `CodeStage` int(11) NULL COMMENT "代号阶段 海阅最大3阶 海剧最大2阶 国剧就1阶",
  `CodeLv` varchar(20) NULL COMMENT "最高阶段投放等级 A|S|SS",
  `PlanKind` int(11) NULL COMMENT "方案类型 1=手动创编|2=A级扩量|3=S级扩量|4=内容测试",
  `PlanTargetType` int(11) NULL COMMENT "方案目标类型 1=语言方案|2=内容方案",
  `PlanContentType` int(11) NULL COMMENT "方案内容类型 海阅且语言方案有效 1=女频现言|2=女频古言|3=女频狼人|4=男频",
  `AdOptimizerUid` varchar(255) NULL COMMENT "优化师工号",
  `ParentPlanId` varchar(255) NULL COMMENT "内容方案的父类语言方案Id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "自动化创编任务表,Auther:102094"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
