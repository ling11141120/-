CREATE TABLE `ods_tidb_readernovel_tidb_xx_stat_data` (
  `productid` int(11) NOT NULL COMMENT "",
  `AutoId` int(11) NOT NULL COMMENT "",
  `BookId` bigint(20) NOT NULL COMMENT "",
  `StatField` varchar(150) NOT NULL COMMENT "",
  `RankClass` varchar(150) NOT NULL COMMENT "",
  `Code` int(11) NOT NULL COMMENT "",
  `Value` bigint(20) NOT NULL COMMENT "",
  `realnum` bigint(20) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `AutoId`)
DISTRIBUTED BY HASH(`AutoId`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
