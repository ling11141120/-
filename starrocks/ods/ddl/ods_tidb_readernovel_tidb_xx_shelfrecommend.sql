CREATE TABLE `ods_tidb_readernovel_tidb_xx_shelfrecommend` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` bigint(20) NOT NULL COMMENT "",
  `Title` varchar(955) NULL COMMENT "标题",
  `Type` int(11) NULL COMMENT "广告类型",
  `ImgUrl` varchar(3000) NULL COMMENT "图片",
  `LinkUrl` varchar(6000) NULL COMMENT "",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `BookTitle` varchar(3000) NULL COMMENT "标题党",
  `BeginTime` datetime NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `IsEnabled` tinyint(4) NULL COMMENT "开启状态",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `CoreVer` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `IsHide` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `IsSmall` tinyint(4) NOT NULL DEFAULT "0" COMMENT "",
  `SmallPt` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `Sex` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `Filters` varchar(65533) NULL COMMENT "",
  `AppId` varchar(1612) NULL COMMENT "",
  `Language` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `IsDelete` int(11) NULL DEFAULT "0" COMMENT "",
  `row_update_time` datetime NULL COMMENT "",
  `SyncLanguage` varchar(600) NULL COMMENT "",
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
