CREATE TABLE `ods_tidb_sv_sharpengine_ads_global_videoroistdcfgdaily_da` (
  `id` bigint(20) NOT NULL COMMENT "主键id",
  `DateKey` varchar(512) NULL COMMENT "有效日期yyyy-MM-dd",
  `StdId` bigint(20) NULL COMMENT "标准Id",
  `VideoId` bigint(20) NULL COMMENT "剧集Id",
  `PutProductId` int(11) NULL COMMENT "投放语言",
  `CurrentLanguage2` int(11) NULL COMMENT "投放语言",
  `Mt` int(11) NULL COMMENT "终端 1=iOS|4=安卓",
  `SourceChl` varchar(512) NULL COMMENT "媒体",
  `R0Std` decimal(10, 4) NULL COMMENT "R0标准",
  `R7Std` decimal(10, 4) NULL COMMENT "R7标准",
  `CpiStd` decimal(10, 4) NULL COMMENT "CPI标准",
  `H24Std` decimal(10, 4) NULL COMMENT "H24标准",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "短剧ROI标准配置 每日数据"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
