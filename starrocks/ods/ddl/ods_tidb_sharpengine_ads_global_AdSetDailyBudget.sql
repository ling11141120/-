CREATE TABLE `ods_tidb_sharpengine_ads_global_AdSetDailyBudget` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `DateKey` date NOT NULL COMMENT "日期yyyy-MM-dd",
  `AdSetId` varchar(300) NULL COMMENT "广告组ID",
  `Dx` int(11) NOT NULL COMMENT "第几天",
  `YesterdayBudget` decimal(20, 4) NULL COMMENT "昨日预算",
  `TodayBudget` decimal(20, 4) NULL COMMENT "当日预算",
  `FirstBudget` decimal(20, 4) NULL COMMENT "当日初始预算",
  `H2Budget` decimal(20, 4) NULL COMMENT "当日H2预算",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `SourceChl` varchar(128) NULL COMMENT "媒体",
  `LastBudgetTime` datetime NULL COMMENT "上次修改预算的时间",
  `AdCampId` varchar(128) NULL COMMENT "广告系列ID",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告组日预算记录表 author:742337"
DISTRIBUTED BY HASH(`Id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
