CREATE TABLE `ods_tidb_shuangwen_en_promotionbooktotal` (
  `Id` int(11) NOT NULL COMMENT "",
  `LanguageName` varchar(150) NULL COMMENT "",
  `Cname` varchar(1500) NULL COMMENT "",
  `FromBooKName` varchar(1500) NULL COMMENT "",
  `ToBookName` varchar(1500) NULL COMMENT "",
  `IsTran` varchar(120) NULL COMMENT "",
  `BookId` bigint(20) NOT NULL DEFAULT "0" COMMENT "",
  `Promotion` varchar(150) NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `RowVersion` bigint(20) NULL COMMENT "",
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
