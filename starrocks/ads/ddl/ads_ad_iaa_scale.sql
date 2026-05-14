CREATE TABLE `ads_ad_iaa_scale` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `AmountDate` varchar(30) NULL COMMENT "日期",
  `ProductId` int(11) NULL COMMENT "产品ID",
  `Mt` int(11) NULL COMMENT "终端",
  `Core` int(11) NULL COMMENT "Core",
  `AdMobRatio` decimal(10, 5) NULL COMMENT "AdMob比例",
  `MaxRatio` decimal(10, 5) NULL COMMENT "Max比例",
  `AdMobRealIncome` decimal(20, 2) NULL COMMENT "AdMob真实收入",
  `AdMobEstimatedIncome` decimal(20, 2) NULL COMMENT "AdMob预估收入",
  `MaxRealIncome` decimal(20, 2) NULL COMMENT "Max真实收入",
  `MaxEstimatedIncome` decimal(20, 2) NULL COMMENT "Max预估收入",
  `CreateTime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "创建时间",
  `UpdateTime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "更新时间",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "ETL清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告收入放大比例"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);