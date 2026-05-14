CREATE TABLE `ods_tidb_shuangwen_en_sensitivewords` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` int(11) NOT NULL COMMENT "",
  `Words` varchar(1500) NULL COMMENT "敏感词",
  `UpdateTime` datetime NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `Language` int(11) NOT NULL COMMENT "",
  `CreateId` varchar(150) NOT NULL COMMENT "",
  `Creator` varchar(150) NULL COMMENT "",
  `ModifId` varchar(150) NULL COMMENT "",
  `Modifier` varchar(150) NULL COMMENT "",
  `DelFlag` int(11) NULL COMMENT "0未删除1已删除",
  `WordsType` int(11) NOT NULL DEFAULT "0" COMMENT "",
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
