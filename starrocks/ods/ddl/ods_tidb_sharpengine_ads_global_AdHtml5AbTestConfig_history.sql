CREATE TABLE `ods_tidb_sharpengine_ads_global_AdHtml5AbTestConfig_history` (
  `Id` bigint(20) NULL COMMENT "",
  `Title` varchar(1024) NULL COMMENT "",
  `ProjectCode` int(11) NULL COMMENT "",
  `Core` int(11) NULL COMMENT "",
  `Page1` varchar(1024) NULL COMMENT "",
  `Page2` varchar(1024) NULL COMMENT "",
  `Page3` varchar(1024) NULL COMMENT "",
  `LpType` varchar(1024) NULL COMMENT "",
  `LpVer` varchar(1024) NULL COMMENT "",
  `DomainLang` varchar(256) NULL COMMENT "",
  `BookCode` varchar(256) NULL COMMENT "",
  `BookId` varchar(256) NULL COMMENT "",
  `PutUrl` varchar(1024) NULL COMMENT "",
  `CurrentLanguage` int(11) NULL COMMENT "",
  `MarketId` varchar(256) NULL COMMENT "",
  `CreateBy` varchar(256) NULL COMMENT "",
  `UpdateBy` varchar(256) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `UpdateTime` datetime NULL COMMENT "",
  `sr_createtime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`Id`, `Title`)
DISTRIBUTED BY RANDOM
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
