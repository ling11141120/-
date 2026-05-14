CREATE TABLE `ods_tidb_sharpengine_ads_global_AdHtml5AbTestConfig` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `Title` varchar(1024) NOT NULL COMMENT "标题",
  `ProjectCode` int(11) NOT NULL COMMENT "项目",
  `Core` int(11) NULL COMMENT "",
  `Page1` varchar(1024) NOT NULL COMMENT "H5 Page1 配置",
  `Page2` varchar(1024) NOT NULL COMMENT "H5 Page2 配置",
  `Page3` varchar(1024) NOT NULL COMMENT "H5 Page3 配置",
  `LpType` varchar(1024) NOT NULL COMMENT "Lp类型",
  `LpVer` varchar(1024) NULL COMMENT "LP版本号",
  `DomainLang` varchar(256) NULL COMMENT "域名语言",
  `BookCode` varchar(256) NULL COMMENT "书籍代号",
  `BookId` varchar(256) NOT NULL COMMENT "书籍ID",
  `PutUrl` varchar(1024) NULL COMMENT "投放URL",
  `CurrentLanguage` int(11) NULL COMMENT "",
  `MarketId` varchar(256) NULL COMMENT "Pixel配置Id",
  `CreateBy` varchar(256) NOT NULL COMMENT "创建人",
  `UpdateBy` varchar(256) NOT NULL COMMENT "更新人",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "H5 AB测配置"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
