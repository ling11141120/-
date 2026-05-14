CREATE TABLE `ods_tidb_shuangwen_xx_authorbookdailyconfig` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` bigint(20) NOT NULL COMMENT "",
  `AuthorSaleRate` varchar(1500) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `CreateId` varchar(150) NULL COMMENT "",
  `ModifId` varchar(150) NULL COMMENT "",
  `ModifyTime` datetime NULL COMMENT "",
  `Language` int(11) NULL DEFAULT "3" COMMENT "",
  `StartTime` datetime NULL COMMENT "",
  `RowVersion` bigint(20) NULL COMMENT "",
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
