CREATE TABLE `ods_tidb_sharpengine_ads_global_ThirdAd` (
  `Id` int(11) NOT NULL COMMENT "",
  `FbAccount` varchar(128) NULL COMMENT "账号id",
  `AdStatus` varchar(50) NULL COMMENT "广告状态",
  `AdId` varchar(128) NULL COMMENT "广告id",
  `AdName` varchar(500) NULL COMMENT "广告名称",
  `AdSetId` varchar(128) NULL COMMENT "广告组id",
  `AdCampId` varchar(128) NULL COMMENT "广告系列id",
  `source_ad_id` varchar(128) NULL COMMENT "",
  `created_time` datetime NULL COMMENT "",
  `bid_type` varchar(50) NULL COMMENT "",
  `bid_amount` decimal(10, 2) NULL COMMENT "",
  `bid_info` varchar(65533) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `UpdateTime` datetime NULL COMMENT "",
  `AdCreativeId` varchar(128) NULL COMMENT "",
  `effective_status` varchar(50) NULL COMMENT "",
  `AdType` varchar(100) NULL COMMENT "",
  `AdPlatformId` int(11) NULL COMMENT "广告渠道 0-苹果 1-抖音 2-快手",
  `SourceChl` varchar(128) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "苹果和国内短剧投放广告id信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AdId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
