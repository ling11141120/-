CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_RoiStdCfgDaily` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `ProjectCode` int(11) NULL COMMENT "项目 1=阅读|2=海外短剧",
  `StdId` bigint(20) NULL COMMENT "ROI标准配置ID",
  `StdVersionId` bigint(20) NULL COMMENT "ROI标准版本配置ID",
  `StdFlowId` bigint(20) NULL COMMENT "ROI标准分流配置ID",
  `StdCode` varchar(500) NULL COMMENT "代号",
  `DateKey` varchar(500) NULL COMMENT "有效日期yyyy-MM-dd",
  `CurrentLanguage` int(11) NULL COMMENT "投放语言",
  `Mt` int(11) NULL COMMENT "终端 1=iOS|4=安卓",
  `SourceChl` varchar(1000) NULL COMMENT "媒体来源",
  `Core` int(11) NULL COMMENT "Core",
  `AdTarget` varchar(500) NULL COMMENT "受众类型",
  `BookChannel` int(11) NULL COMMENT "书频",
  `BookType` int(11) NULL COMMENT "书籍类型",
  `CpiStd` decimal(10, 4) NULL COMMENT "CPI标准",
  `H24Std` decimal(10, 4) NULL COMMENT "H24标准",
  `R0Std` decimal(10, 4) NULL COMMENT "R0标准",
  `R7Std` decimal(10, 4) NULL COMMENT "R7标准",
  `RecoveryStd` decimal(10, 4) NULL COMMENT "回本目标标准",
  `FlowRatio` decimal(12, 4) NULL COMMENT "流量分配占比",
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
