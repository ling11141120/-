CREATE TABLE `ods_tidb_accountdb_tidb_hk_exaccount_exaccount` (
  `ExType` int(11) NOT NULL COMMENT "",
  `ExId` varchar(512) NOT NULL COMMENT "",
  `Id` bigint(20) NOT NULL COMMENT "",
  `ExNick` varchar(256) NULL COMMENT "",
  `BindTime` datetime NOT NULL COMMENT "",
  `AccessToken` varchar(65533) NULL COMMENT "",
  `TempToken` varchar(132) NULL COMMENT "",
  `TempTokenTime` datetime NULL COMMENT "",
  `Password` varchar(428) NULL COMMENT "",
  `UnionId` varchar(428) NULL COMMENT "",
  `OpenId` varchar(428) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`ExType`, `ExId`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
