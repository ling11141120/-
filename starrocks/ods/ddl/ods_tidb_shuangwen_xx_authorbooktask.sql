CREATE TABLE `ods_tidb_shuangwen_xx_authorbooktask` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` bigint(20) NOT NULL COMMENT "",
  `BookId` int(11) NOT NULL COMMENT "",
  `TaskTime` datetime NULL COMMENT "",
  `TaskStatus` int(11) NULL DEFAULT "1" COMMENT "",
  `TaskId` varchar(150) NULL COMMENT "",
  `ChapterId` bigint(20) NULL DEFAULT "0" COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `Language` int(11) NOT NULL DEFAULT "0" COMMENT "",
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
