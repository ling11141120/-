CREATE TABLE `ods_tidb_sv_sharpengine_ads_global_PutProductVideoRoiStdCfgDaily` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `DateKey` varchar(65533) NULL COMMENT "有效日期yyyy-MM-dd",
  `StdId` bigint(20) NULL COMMENT "标准Id",
  `PutProductId` int(11) NULL COMMENT "投放语言",
  `Mt` int(11) NULL COMMENT "终端 1=iOS|4=安卓",
  `SourceChl` varchar(65533) NULL COMMENT "媒体",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `R0Std` decimal(10, 4) NULL COMMENT "R0标准",
  `R7Std` decimal(10, 4) NULL COMMENT "R7标准",
  `CpiStd` decimal(10, 4) NULL COMMENT "CPI标准",
  `H24Std` decimal(10, 4) NULL COMMENT "H24标准",
  `CurrentLanguage2` int(11) NULL COMMENT "投放语言",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧投放语言ROI标准配置"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
