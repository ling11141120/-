CREATE TABLE `ods_tidb_sharpengine_ads_global_BookRoiStdCfg` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `DateKey` varchar(65533) NULL COMMENT "有效日期yyyy-MM-dd",
  `BookId` bigint(20) NULL COMMENT "书籍Id",
  `Mt` int(11) NULL COMMENT "终端 1=iOS|4=安卓",
  `PutProductId` int(11) NULL COMMENT "投放语言",
  `CurrentLanguage2` int(11) NULL COMMENT "投放语言",
  `R0Std` decimal(10, 4) NULL COMMENT "R0标准",
  `R7Std` decimal(10, 4) NULL COMMENT "R7标准",
  `CpiStd` decimal(10, 4) NULL COMMENT "CPI标准",
  `RecoveryStd` decimal(10, 4) NULL COMMENT "回本目标标准",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `CreateBy` varchar(65533) NULL COMMENT "创建人",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `UpdateBy` varchar(65533) NULL COMMENT "更新人",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "书籍ROI标准配置"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, DateKey",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
