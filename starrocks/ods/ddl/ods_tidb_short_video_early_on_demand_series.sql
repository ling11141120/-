CREATE TABLE `ods_tidb_short_video_early_on_demand_series` (
  `Id` bigint(20) NOT NULL COMMENT "唯一ID",
  `SeriesId` bigint(20) NULL COMMENT "剧集id",
  `LangId` int(11) NULL COMMENT "语言id",
  `Status` int(11) NULL COMMENT "状态 1:生效 2:失效",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `InvalidTime` datetime NULL COMMENT "失效时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧-超点统计出入明细表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
