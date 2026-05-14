CREATE TABLE `ods_tidb_sharpengine_ads_global_FbAd` (
  `Id` int(11) NOT NULL COMMENT "",
  `FbAccount` varchar(256) NULL COMMENT "账号id",
  `AdStatus` varchar(100) NULL COMMENT "广告状态",
  `AdId` varchar(256) NULL COMMENT "广告id",
  `AdName` varchar(1000) NULL COMMENT "广告名称",
  `AdSetId` varchar(256) NULL COMMENT "广告组id",
  `AdCampId` varchar(256) NULL COMMENT "广告系列id",
  `source_ad_id` varchar(256) NULL COMMENT "",
  `created_time` datetime NULL COMMENT "",
  `bid_type` varchar(100) NULL COMMENT "",
  `bid_amount` decimal(10, 2) NULL COMMENT "",
  `bid_info` varchar(65533) NULL COMMENT "",
  `adcreatives` varchar(65533) NULL COMMENT "",
  `AdCreativeId` varchar(256) NULL COMMENT "",
  `effective_status` varchar(100) NULL COMMENT "",
  `ApiOpenFlag` int(11) NULL COMMENT "",
  `RowVersion` bigint(20) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `UpdateTime` datetime NULL COMMENT "",
  `GroupId` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "飞书投放广告id记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AdId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
