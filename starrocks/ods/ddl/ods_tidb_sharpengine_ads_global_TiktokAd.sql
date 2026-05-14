CREATE TABLE `ods_tidb_sharpengine_ads_global_TiktokAd` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `FbAccount` varchar(128) NULL COMMENT "",
  `AdStatus` varchar(50) NULL COMMENT "",
  `AdId` varchar(128) NULL COMMENT "",
  `AdName` varchar(500) NULL COMMENT "",
  `AdSetId` varchar(128) NULL COMMENT "",
  `AdCampId` varchar(128) NULL COMMENT "",
  `source_ad_id` varchar(128) NULL COMMENT "",
  `created_time` datetime NULL COMMENT "",
  `bid_type` varchar(50) NULL COMMENT "",
  `bid_amount` decimal(10, 2) NULL COMMENT "",
  `bid_info` varchar(65533) NULL COMMENT "",
  `adcreatives` varchar(65533) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `UpdateTime` datetime NULL COMMENT "",
  `AdCreativeId` varchar(128) NULL COMMENT "",
  `effective_status` varchar(50) NULL COMMENT "",
  `ApiOpenFlag` int(11) NULL COMMENT "",
  `RowVersion` bigint(20) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AdId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
