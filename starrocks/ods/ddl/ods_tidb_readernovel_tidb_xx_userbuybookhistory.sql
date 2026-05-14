CREATE TABLE `ods_tidb_readernovel_tidb_xx_userbuybookhistory` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `UserId` bigint(20) NOT NULL COMMENT "",
  `BookId` bigint(20) NOT NULL COMMENT "",
  `Chapters` varchar(65533) NULL COMMENT "",
  `Indexs` varchar(65533) NOT NULL COMMENT "",
  `Audio` varchar(65533) NULL COMMENT "",
  `AutoId` bigint(20) NOT NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `UserId`, `BookId`)
COMMENT "书籍购买历史"
DISTRIBUTED BY HASH(`BookId`) BUCKETS 40 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
