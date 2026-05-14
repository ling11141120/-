CREATE TABLE `ods_tidb_readernovel_tidb_devicetoken` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "",
  `Token` varchar(500) NULL COMMENT "",
  `MT` int(11) NULL COMMENT "",
  `UserId` bigint(20) NULL COMMENT "",
  `IsAllowNotify` int(11) NULL COMMENT "",
  `UnReadNum` int(11) NULL COMMENT "",
  `BundleId` varchar(500) NULL COMMENT "",
  `LastActivityTime` datetime NULL COMMENT "",
  `IsNotAllowNotify` int(11) NULL COMMENT "",
  `IsInvalid` int(11) NULL COMMENT "",
  `Bookshelf` varchar(65533) NULL COMMENT "",
  `Chl` varchar(500) NULL COMMENT "",
  `RegTime` datetime NULL COMMENT "",
  `ClientId` varchar(500) NULL COMMENT "",
  `DeviceGuid` varchar(500) NULL COMMENT "",
  `Ver` int(11) NULL COMMENT "",
  `SentMsgId` bigint(20) NULL COMMENT "",
  `IP` varchar(500) NULL COMMENT "",
  `appver` varchar(500) NULL COMMENT "",
  `ProdId` varchar(500) NULL COMMENT "",
  `Sex` int(11) NULL COMMENT "",
  `sysreleasever` varchar(500) NULL COMMENT "",
  `DeviceName` varchar(65533) NULL COMMENT "",
  `TokenType` int(11) NULL COMMENT "",
  `AndroidIdForDeviceGUID` varchar(500) NULL COMMENT "",
  `Core` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "Id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
