CREATE TABLE `ods_tidb_short_video_log_log_installreferrerlog` (
  `id` bigint(20) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `AppId` int(11) NULL COMMENT "",
  `Appver` varchar(255) NULL COMMENT "",
  `Chl` varchar(255) NULL COMMENT "",
  `Mt` int(11) NULL COMMENT "",
  `Core` int(11) NULL COMMENT "",
  `RowData` varchar(65533) NULL COMMENT "",
  `DecryptData` varchar(65533) NULL COMMENT "",
  `UniqueCdReaderId` varchar(255) NULL COMMENT "",
  `CurrentLanguage` int(11) NULL COMMENT "",
  `regionId` smallint(6) NULL DEFAULT "1" COMMENT "归属区域 id，1：香港，2：北美；",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`, `CreateTime`)
COMMENT "海外短剧-短剧DL拉起记录表"
DISTRIBUTED BY HASH(`id`) BUCKETS 250 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
