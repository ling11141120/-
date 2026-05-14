CREATE TABLE `ods_tidb_readernovel_xx_mysql_signrewardcfg` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` int(11) NOT NULL COMMENT "主键ID",
  `Core` varchar(150) NULL COMMENT "Core 空为全部 多个用逗号分隔",
  `Platform` int(11) NOT NULL COMMENT "MT系统",
  `UserType` varchar(955) NOT NULL COMMENT "用户类型",
  `UserTypeConfig` varchar(6000) NULL COMMENT "用户类型配置信息",
  `IsSpecialPrize` tinyint(4) NOT NULL COMMENT "否是大奖",
  `Days` int(11) NOT NULL COMMENT "天",
  `ModifId` varchar(150) NULL COMMENT "",
  `ModifyTime` datetime NULL COMMENT "",
  `CreateId` varchar(150) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "Id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
