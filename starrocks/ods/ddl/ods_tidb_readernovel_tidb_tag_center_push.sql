CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_push` (
  `Id` int(11) NOT NULL COMMENT "策略id",
  `MainId` int(11) NOT NULL COMMENT "活动id",
  `GroupIds` varchar(65533) NOT NULL COMMENT "",
  `BookId` bigint(20) NOT NULL COMMENT "",
  `Status` int(11) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `LangId` int(11) NOT NULL COMMENT "",
  `BookName` varchar(65533) NOT NULL COMMENT "",
  `ActionName` varchar(65533) NULL COMMENT "",
  `ReceptType` tinyint(4) NOT NULL DEFAULT "0" COMMENT "",
  `ArithmeticId` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `ActivityUrl` varchar(65533) NULL COMMENT "",
  `ReceptPage` int(11) NOT NULL DEFAULT "1" COMMENT "承接页",
  `JGroupIds` varchar(65533) NULL COMMENT "极光人群包",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "tag后台,push活动-记录活动id和策略id的配置表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
