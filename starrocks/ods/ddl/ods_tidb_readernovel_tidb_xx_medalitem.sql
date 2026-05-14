CREATE TABLE `ods_tidb_readernovel_tidb_xx_medalitem` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL DEFAULT "0" COMMENT "",
  `Pid` bigint(20) NOT NULL DEFAULT "0" COMMENT "",
  `MedalNum` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `ExpireTime` datetime NOT NULL COMMENT "",
  `Source` varchar(955) NULL COMMENT "",
  `SendNum` int(11) NULL COMMENT "",
  `SendTime` datetime NULL COMMENT "",
  `SourceKey` varchar(955) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
