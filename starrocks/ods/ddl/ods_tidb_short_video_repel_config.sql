CREATE TABLE `ods_tidb_short_video_repel_config` (
  `Id` bigint(20) NOT NULL COMMENT "唯一ID",
  `RgId` bigint(20) NULL COMMENT "互斥组ID",
  `SeriesId` bigint(20) NULL COMMENT "短剧集ID",
  `SortNum` tinyint(4) NULL COMMENT "排序",
  `sr_updatetime` datetime NULL COMMENT "ods同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "互斥配置 author：232618"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
