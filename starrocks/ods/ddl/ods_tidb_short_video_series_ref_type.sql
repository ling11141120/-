CREATE TABLE `ods_tidb_short_video_series_ref_type` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `SeriesId` bigint(20) NULL COMMENT "剧集Id",
  `SeriesTypeId` bigint(20) NULL COMMENT "剧集类型Id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海外短剧-剧分类维度表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
