CREATE TABLE `ods_tidb_readernovel_tidb_xx_novel_flashsale` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` int(11) NOT NULL COMMENT "",
  `BookId` bigint(20) NOT NULL COMMENT "",
  `BeginTime` datetime NOT NULL COMMENT "",
  `EndTime` datetime NOT NULL COMMENT "",
  `IsTotalFree` tinyint(4) NOT NULL COMMENT "",
  `FreeChapters` int(11) NOT NULL COMMENT "",
  `Channels` varchar(65533) NULL COMMENT "",
  `AutoRecommend` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `RecommentType` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `AppId` varchar(1512) NULL COMMENT "",
  `Language` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `IsDelete` int(11) NULL DEFAULT "0" COMMENT "",
  `row_update_time` datetime NULL COMMENT "",
  `SyncLanguage` varchar(600) NULL DEFAULT "" COMMENT "",
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
