CREATE TABLE `ods_tidb_sharpengine_analysis_tidb_ads_tts2s_sender` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `UserId` bigint(20) NOT NULL COMMENT "",
  `PixelId` varchar(528) NOT NULL COMMENT "",
  `Data` varchar(65533) NOT NULL COMMENT "",
  `Status` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `FinishTime` datetime NULL COMMENT "",
  `EventType` varchar(150) NULL COMMENT "",
  `DescInfo` varchar(65533) NULL COMMENT "",
  `OrderSerialId` varchar(300) NULL COMMENT "",
  `EventTime` datetime NULL COMMENT "",
  `PageViewTime` datetime NULL COMMENT "",
  `AdId` varchar(600) NULL COMMENT "",
  `TraceId` varchar(528) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
