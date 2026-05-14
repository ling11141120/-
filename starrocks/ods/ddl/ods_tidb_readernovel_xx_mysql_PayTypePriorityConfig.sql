CREATE TABLE `ods_tidb_readernovel_xx_mysql_PayTypePriorityConfig` (
  `productid` int(11) NOT NULL COMMENT "产品Id",
  `Id` int(11) NOT NULL COMMENT "Id",
  `Country` varchar(1000) NULL COMMENT "国家地区",
  `Status` int(11) NOT NULL COMMENT "Status",
  `PayMent` varchar(128) NOT NULL COMMENT "PayMent",
  `Payment_ID` varchar(32) NOT NULL COMMENT "Payment_ID",
  `PayMent_Fee` decimal(19, 2) NOT NULL COMMENT "PayMent_Fee",
  `Fixed_Charge` decimal(19, 2) NULL COMMENT "Fixed_Charge",
  `Minimum_amount` decimal(32, 10) NOT NULL COMMENT "Minimum_amount",
  `Payment_Rules` int(11) NOT NULL COMMENT "Payment_Rules",
  `ImageUrl` varchar(1000) NULL COMMENT "ImageUrl",
  `ImageUrl1` varchar(200) NULL COMMENT "ImageUrl1",
  `PayType` int(11) NULL COMMENT "",
  `PayMent_Way` varchar(1000) NULL COMMENT "支付渠道",
  `CreatedBy` varchar(100) NULL COMMENT "创建人",
  `CreatedTime` datetime NULL COMMENT "创建时间",
  `UpdatedBy` varchar(100) NULL COMMENT "更新人",
  `UpdatedTime` datetime NULL COMMENT "更新时间",
  `Platform` int(11) NULL DEFAULT "0" COMMENT "",
  `ShowType` int(11) NULL DEFAULT "0" COMMENT "",
  `IsDelete` int(11) NULL DEFAULT "0" COMMENT "",
  `row_update_time` datetime NULL COMMENT "",
  `SyncLanguage` varchar(700) NULL COMMENT "",
  `Language` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "支付类型配置"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
