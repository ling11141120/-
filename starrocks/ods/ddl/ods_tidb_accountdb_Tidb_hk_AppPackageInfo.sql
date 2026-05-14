CREATE TABLE `ods_tidb_accountdb_Tidb_hk_AppPackageInfo` (
  `Id` int(11) NOT NULL COMMENT "自增id",
  `ProductId` int(11) NULL COMMENT "产品id",
  `ProductName` varchar(765) NULL COMMENT "app名称",
  `PackageName` varchar(765) NULL COMMENT "包名",
  `Core` int(11) NULL COMMENT "core（包体）",
  `Mt` int(11) NULL COMMENT "平台",
  `AppStoreShareKey` varchar(765) NULL COMMENT "AppStoreShareKey",
  `Createtime` datetime NULL COMMENT "创建时间",
  `ProductName2` varchar(765) NULL COMMENT "app名称2",
  `Chl2` varchar(765) NULL COMMENT "Chl2",
  `RowVersion` varchar(765) NULL COMMENT "RowVersion",
  `AppId` varchar(765) NULL COMMENT "AppId",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "阅读-客户端包名信息(app)"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
