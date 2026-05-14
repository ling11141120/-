CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_RoiStdCfgFlowTag` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `Dt` varchar(500) NULL COMMENT "日期",
  `AdSetId` varchar(500) NULL COMMENT "广告组ID",
  `ProjectCode` int(11) NULL COMMENT "项目 1=阅读|2=海外短剧",
  `CurrentLanguage` int(11) NULL COMMENT "投放语言",
  `Mt` int(11) NULL COMMENT "终端 1=iOS|4=安卓",
  `SourceChl` varchar(1000) NULL COMMENT "媒体来源",
  `Core` int(11) NULL COMMENT "Core",
  `AdTarget` varchar(500) NULL COMMENT "受众类型",
  `BookChannel` int(11) NULL COMMENT "书频",
  `BookType` int(11) NULL COMMENT "书籍类型",
  `BookId` bigint(20) NULL COMMENT "书籍ID",
  `StdId` bigint(20) NULL COMMENT "ROI标准配置ID",
  `StdVersionId` bigint(20) NULL COMMENT "ROI标准版本配置ID",
  `StdFlowId` bigint(20) NULL COMMENT "ROI标准分流配置ID",
  `StdDailyId` bigint(20) NULL COMMENT "ROI标准每日记录ID",
  `StdCode` varchar(500) NULL COMMENT "代号",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告-ROI标准每日记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
