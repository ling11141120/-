CREATE TABLE `ods_tidb_shuangwen_xx_bookchannelincomeconfig` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `Language` int(11) NULL COMMENT "",
  `DelFlag` int(11) NULL DEFAULT "0" COMMENT "",
  `StartTime` datetime NULL COMMENT "",
  `BookId` int(11) NOT NULL COMMENT "",
  `SiteId` int(11) NOT NULL COMMENT "",
  `ChannelBookId` int(11) NOT NULL COMMENT "",
  `AuthorId` bigint(20) NOT NULL COMMENT "",
  `Rate` double NOT NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
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
