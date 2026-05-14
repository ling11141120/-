CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_activity` (
  `Id` int(11) NOT NULL COMMENT "",
  `Name` varchar(1500) NOT NULL COMMENT "",
  `LangId` int(11) NOT NULL COMMENT "",
  `GroupIds` varchar(300) NOT NULL COMMENT "",
  `Status` tinyint(4) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `TemplateId` int(11) NOT NULL COMMENT "",
  `MainId` int(11) NOT NULL COMMENT "",
  `ActivityUrl` varchar(955) NULL COMMENT "",
  `ReceptPage` int(11) NOT NULL COMMENT "承接页",
  `JGroupIds` varchar(300) NULL COMMENT "极光人群包",
  `BillId` int(11) NOT NULL COMMENT "书单Id",
  `ArithmeticId` int(11) NOT NULL COMMENT "算法Id",
  `ShowRule` int(11) NOT NULL COMMENT "展示规则",
  `FilterType` varchar(30) NULL COMMENT "过滤规则",
  `ExposureRule` int(11) NOT NULL COMMENT "过曝规则",
  `ExposureCount` int(11) NOT NULL COMMENT "过曝次数",
  `CostId` int(11) NOT NULL COMMENT "方案Id",
  `CombinPageId` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `SecondArithmeticId` int(11) NOT NULL DEFAULT "0" COMMENT "算法ID2",
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
