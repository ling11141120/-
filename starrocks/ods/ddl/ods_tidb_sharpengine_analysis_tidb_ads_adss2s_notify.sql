CREATE TABLE `ods_tidb_sharpengine_analysis_tidb_ads_adss2s_notify` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `ua` varchar(1512) NULL COMMENT "",
  `ip` varchar(50) NULL COMMENT "",
  `TraceId` varchar(1128) NOT NULL COMMENT "",
  `RawUrl` varchar(65533) NULL COMMENT "",
  `adid` varchar(1128) NULL COMMENT "",
  `type` varchar(1255) NULL COMMENT "",
  `phone` varchar(1128) NULL COMMENT "",
  `country` varchar(1255) NULL COMMENT "",
  `appid` bigint(20) NULL COMMENT "",
  `c2rtime` datetime NULL COMMENT "",
  `remark` varchar(1500) NULL COMMENT "",
  `chapterindex` varchar(1128) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
