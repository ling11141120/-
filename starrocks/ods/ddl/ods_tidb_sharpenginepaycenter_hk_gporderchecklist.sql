CREATE TABLE `ods_tidb_sharpenginepaycenter_hk_gporderchecklist` (
  `dt` date NOT NULL COMMENT "createtime 分区",
  `Id` int(11) NOT NULL COMMENT "",
  `OrderID` varchar(50) NOT NULL COMMENT "",
  `OrderTime` datetime NULL COMMENT "",
  `AppName` varchar(50) NULL COMMENT "",
  `OrderType` varchar(50) NULL COMMENT "",
  `OrderStatus` varchar(50) NULL COMMENT "",
  `OrderMoney` varchar(50) NULL COMMENT "",
  `AddTime` datetime NULL COMMENT "",
  `IsRenew` int(11) NULL COMMENT "",
  `IsLosed` int(11) NULL COMMENT "",
  `IsSent` int(11) NULL COMMENT "",
  `SKU` varchar(50) NULL COMMENT "",
  `Token` varchar(500) NULL COMMENT "",
  `PackageName` varchar(50) NULL COMMENT "",
  `IsZeroMoney` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `ZeroMoneySentToServer` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `HistoryOrderId` varchar(50) NULL COMMENT "",
  `OrderTime1` datetime NULL COMMENT "",
  `OrderTime2` datetime NULL COMMENT "",
  `OrderTime3` datetime NULL COMMENT "",
  `RowVersion` bigint(20) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `Id`)
COMMENT "补单信息表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AddTime, OrderID",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
