CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdSetDailySpend` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `DateKey` varchar(500) NULL COMMENT "日期yyyy-MM-dd",
  `PreDateKey` varchar(500) NULL COMMENT "昨日日期yyyy-MM-dd",
  `NextDateKey` varchar(500) NULL COMMENT "明日日期yyyy-MM-dd",
  `AdSetId` varchar(500) NULL COMMENT "广告组ID",
  `TodaySpend` decimal(10, 4) NULL COMMENT "当日花费",
  `IsFirstDay` int(11) NULL COMMENT "是否首日 0 - 否 1 - 是",
  `YesterdaySpend` decimal(10, 4) NULL COMMENT "昨日花费",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `SourceChl` varchar(500) NULL COMMENT "媒体",
  `GapDay` int(11) NULL COMMENT "停投天数",
  `R0Std` decimal(10, 4) NULL COMMENT "当日D0标准",
  `TodayD0Amount` decimal(10, 4) NULL COMMENT "当日D0收入",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告组日花费记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
