CREATE TABLE `ods_tidb_sharpengine_analysis_tidb_ads_custom_sender` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `UserId` bigint(20) NOT NULL COMMENT "",
  `PixelId` varchar(528) NULL COMMENT "",
  `Data` varchar(65533) NOT NULL COMMENT "",
  `Status` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `FinishTime` datetime NULL COMMENT "",
  `OrderSerialId` varchar(800) NULL COMMENT "",
  `EventType` varchar(150) NULL COMMENT "",
  `DescInfo` varchar(65533) NULL COMMENT "",
  `EventTime` datetime NULL COMMENT "",
  `PageViewTime` datetime NULL COMMENT "",
  `AdId` varchar(600) NULL COMMENT "",
  `TraceId` varchar(528) NULL COMMENT "",
  `c2rtime` datetime NULL COMMENT "",
  `ErrorMsg` varchar(65533) NULL COMMENT "",
  `PayAmount` int(11) NULL DEFAULT "0" COMMENT "",
  `IsFirstPayOrder` int(11) NULL DEFAULT "0" COMMENT "",
  `AccountCreateTime` datetime NULL COMMENT "",
  `TotalTime` int(11) NULL COMMENT "",
  `SenderType` varchar(800) NULL COMMENT "",
  `ProductId` int(11) NULL DEFAULT "0" COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
