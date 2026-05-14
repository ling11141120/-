CREATE TABLE `ods_tidb_readerlog_xx_Log_FirstPreLoadEventLog` (
  `productid` varchar(50) NOT NULL COMMENT "",
  `Id` bigint(20) NOT NULL COMMENT "",
  `UserId` bigint(20) NULL COMMENT "",
  `Action` varchar(1000) NULL COMMENT "",
  `ProdId` varchar(1000) NULL COMMENT "",
  `Chl` varchar(1000) NULL COMMENT "",
  `IMEI` varchar(1000) NULL COMMENT "",
  `mt` int(11) NULL COMMENT "",
  `appver` varchar(1000) NULL COMMENT "",
  `smallpt` varchar(1000) NULL COMMENT "",
  `F0` bigint(20) NULL COMMENT "",
  `F1` bigint(20) NULL COMMENT "",
  `F2` bigint(20) NULL COMMENT "",
  `F3` bigint(20) NULL COMMENT "",
  `F4` bigint(20) NULL COMMENT "",
  `F5` bigint(20) NULL COMMENT "",
  `F6` bigint(20) NULL COMMENT "",
  `F7` bigint(20) NULL COMMENT "",
  `F8` bigint(20) NULL COMMENT "",
  `F9` bigint(20) NULL COMMENT "",
  `S0` varchar(65533) NULL COMMENT "",
  `S1` varchar(65533) NULL COMMENT "",
  `S2` varchar(65533) NULL COMMENT "",
  `S3` varchar(65533) NULL COMMENT "",
  `S4` varchar(65533) NULL COMMENT "",
  `S5` varchar(65533) NULL COMMENT "",
  `S6` varchar(65533) NULL COMMENT "",
  `S7` varchar(65533) NULL COMMENT "",
  `S8` varchar(65533) NULL COMMENT "",
  `S9` varchar(65533) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `AppId` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "兴趣标签日志,author:014217"
DISTRIBUTED BY HASH(`productid`, `Id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
