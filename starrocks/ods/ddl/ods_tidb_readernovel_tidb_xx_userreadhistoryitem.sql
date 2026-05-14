CREATE TABLE `ods_tidb_readernovel_tidb_xx_userreadhistoryitem` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "",
  `BookId` bigint(20) NULL COMMENT "",
  `LastReadTime` datetime NULL COMMENT "",
  `Pid` bigint(20) NOT NULL COMMENT "",
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
