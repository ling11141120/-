CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdsCreationPlan` (
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `PlanId` varchar(200) NULL COMMENT "方案Id",
  `ProjectCode` int(11) NULL COMMENT "项目 1海阅|2海剧",
  `Name` varchar(1000) NULL COMMENT "方案名称",
  `CurrentLanguage` int(11) NULL COMMENT "投放语言",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `PlanStatus` int(11) NULL COMMENT "方案状态 0 关闭 1 开启",
  `DelFlag` int(11) NULL COMMENT "是否删除 1 已删除",
  `CreateByUid` varchar(500) NULL COMMENT "创建人",
  `CreateBy` varchar(500) NULL COMMENT "创建人",
  `UpdateByUid` varchar(500) NULL COMMENT "更新人",
  `UpdateBy` varchar(500) NULL COMMENT "更新人",
  `PlanKind` int(11) NULL COMMENT "方案类型 1 一阶 2 二阶扩量",
  `SourceChl` varchar(500) NULL COMMENT "媒体",
  `PlanTargetType` int(11) NULL COMMENT "方案目标类型 1=语言方案|2=内容方案",
  `PlanContentType` int(11) NULL COMMENT "方案内容类型 海阅且语言方案有效 1=女频现言|2=女频古言|3=女频狼人|4=男频",
  `CodeId` varchar(500) NULL COMMENT "内容ID ProjectCode为1=书籍ID|ProjectCode为2=短剧ID",
  `AdOptimizerUid` varchar(500) NULL COMMENT "优化师工号",
  `AdOptimizerName` varchar(500) NULL COMMENT "优化师名称",
  `PlanItemUpLimit` int(11) NULL COMMENT "该方案最多同时在跑模板数量。初始化时，根据模板优先级从高往低开",
  `AccountTz` int(11) NULL COMMENT "时区",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "创编广告 方案"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
