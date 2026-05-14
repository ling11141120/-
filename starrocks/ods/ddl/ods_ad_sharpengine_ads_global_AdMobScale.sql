CREATE TABLE `ods_ad_sharpengine_ads_global_AdMobScale` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `AmountDate` datetime NOT NULL COMMENT "",
  `ProductId` int(11) NOT NULL COMMENT "",
  `Mt` int(11) NOT NULL COMMENT "",
  `Core` int(11) NOT NULL COMMENT "",
  `Ratio` decimal(10, 5) NOT NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `UpdateTime` datetime NULL COMMENT "",
  `AmountDateStr` varchar(10) NULL COMMENT "",
  `sr_createtime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告收入放大比例"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
