CREATE TABLE `ods_tidb_sharpengine_ads_global_AdBase` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `ProductId` int(11) NULL COMMENT "",
  `PutType` int(11) NULL COMMENT "1.W2a 2.直投 0.默认",
  `MediaType` int(11) NULL COMMENT "广告类型 1.facebook 2.tiktok 3.googleuac 等,需要制定枚举",
  `AdvertiserAccount` varchar(500) NULL COMMENT "广告投放账号",
  `AdAccountType` int(11) NULL COMMENT "1再营销 0是正常广告",
  `AdId` varchar(500) NOT NULL COMMENT "广告ID",
  `AdSetId` varchar(500) NULL COMMENT "广告组ID",
  `AdCampId` varchar(500) NULL COMMENT "广告系列",
  `BookId` bigint(20) NULL COMMENT "书籍ID",
  `Lp` varchar(1000) NULL COMMENT "landingpage",
  `PixelId` varchar(500) NULL COMMENT "pixelid",
  `AdsType` varchar(500) NULL COMMENT "AdsType,内部类型,如AEO,VO等",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "更新时间",
  `AdName` varchar(1000) NULL COMMENT "广告名称",
  `AdSetName` varchar(1000) NULL COMMENT "广告组名称",
  `AdCampName` varchar(1000) NULL COMMENT "广告系列名称",
  `Mt` int(11) NULL COMMENT "",
  `Core` int(11) NULL COMMENT "",
  `Chl2` varchar(500) NULL COMMENT "",
  `CurrentLanguage2` int(11) NULL COMMENT "",
  `SourceChl` varchar(500) NULL COMMENT "",
  `AccountTz` int(11) NOT NULL DEFAULT "-13" COMMENT "账号时区 -13=GMT-5默认时区|-20=GMT-12英西时区|-18=GMT-10葡语时区|-7=GMT+1亚洲时区",
  `DataSource` int(11) NULL COMMENT "数据来源",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "OLAP"
DISTRIBUTED BY HASH(`Id`) BUCKETS 6 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AdId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
