CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_BookRoiStdCfgV2Daily` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `DateKey` varchar(128) NULL COMMENT "有效日期yyyy-MM-dd",
  `StdId` bigint(20) NULL COMMENT "标准Id",
  `BookId` bigint(20) NULL COMMENT "书籍Id",
  `Mt` int(11) NULL COMMENT "终端 1=iOS|4=安卓",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `R0Std` decimal(10, 4) NULL COMMENT "R0标准",
  `R7Std` decimal(10, 4) NULL COMMENT "R7标准",
  `CpiStd` decimal(10, 4) NULL COMMENT "CPI标准",
  `H24Std` decimal(10, 4) NULL COMMENT "H24标准",
  `CurrentLanguage2` int(11) NULL COMMENT "投放语言",
  `SourceChl` varchar(1000) NULL COMMENT "媒体来源",
  `AdTarget` varchar(1000) NULL COMMENT "受众类型",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告-书籍ROI标准配置 每日数据"
DISTRIBUTED BY HASH(`Id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
