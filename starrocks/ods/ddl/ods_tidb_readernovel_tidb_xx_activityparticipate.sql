CREATE TABLE `ods_tidb_readernovel_tidb_xx_activityparticipate` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "",
  `Pid` bigint(20) NOT NULL COMMENT "",
  `Type` int(11) NULL COMMENT "",
  `LastParticipateTime` datetime NULL COMMENT "",
  `GameOrBannerId` bigint(20) NULL COMMENT "",
  `LogType` int(11) NULL COMMENT "",
  `ClickType` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 70 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
