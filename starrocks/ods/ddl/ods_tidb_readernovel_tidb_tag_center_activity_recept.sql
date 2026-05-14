CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_activity_recept` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `ReceptType` int(11) NOT NULL COMMENT "承接类型 1=书籍",
  `MainId` int(11) NOT NULL COMMENT "",
  `ActionId` int(11) NOT NULL COMMENT "",
  `BookId` bigint(20) NULL COMMENT "",
  `BookName` varchar(955) NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `LangId` int(11) NOT NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "OLAP"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
