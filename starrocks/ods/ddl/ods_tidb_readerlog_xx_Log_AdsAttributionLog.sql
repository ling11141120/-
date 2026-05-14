CREATE TABLE `ods_tidb_readerlog_xx_Log_AdsAttributionLog` (
  `productid` varchar(255) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "",
  `UserId` bigint(20) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `AppId` int(11) NULL COMMENT "",
  `Appver` varchar(1000) NULL COMMENT "",
  `Chl` varchar(1000) NULL COMMENT "",
  `Mt` int(11) NULL COMMENT "",
  `Core` int(11) NULL COMMENT "",
  `RowData` varchar(65533) NULL COMMENT "",
  `DecryptData` varchar(65533) NULL COMMENT "",
  `UniqueCdReaderId` varchar(1000) NULL COMMENT "",
  `CurrentLanguage` int(11) NULL COMMENT "",
  `Sdk` int(11) NULL COMMENT "",
  `HasOpen` int(11) NULL COMMENT "客户端上报isOpen,首次打开",
  `SeriesId` varchar(1000) NULL COMMENT "拉起书籍id",
  `DefaultDLType` int(11) NULL COMMENT " 1202的dl数据类型，对应1202的下发的type",
  `DefaultDLLinkType` int(11) NULL COMMENT "1202的type=0后的链接类型，对应1202的下发的Linktype",
  `Duration` decimal(10, 2) NULL COMMENT "客户端请求耗时",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "海阅-阅读归因表"
DISTRIBUTED BY HASH(`productid`, `Id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
