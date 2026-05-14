CREATE TABLE `ods_tidb_shuangwen_xx_tagconfig` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` bigint(20) NOT NULL COMMENT "",
  `Category` varchar(1255) NULL COMMENT "",
  `Tag` varchar(1255) NULL COMMENT "",
  `SiteId` int(11) NULL DEFAULT "0" COMMENT "",
  `CreatedBy` varchar(1255) NULL COMMENT "",
  `CreatedTime` datetime NULL COMMENT "",
  `UpdatedBy` varchar(1255) NULL COMMENT "",
  `UpdatedTime` datetime NULL COMMENT "",
  `IsDelete` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `RowVersion` bigint(20) NULL COMMENT "",
  `Sort` int(11) NULL DEFAULT "0" COMMENT "",
  `Status` int(11) NULL DEFAULT "0" COMMENT "",
  `CategoryRemark` varchar(150) NULL DEFAULT "" COMMENT "",
  `TagRemark` varchar(150) NULL DEFAULT "" COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`productid`, `Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
