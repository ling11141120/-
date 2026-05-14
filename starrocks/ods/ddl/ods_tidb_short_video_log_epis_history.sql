CREATE TABLE `ods_tidb_short_video_log_epis_history` (
  `Id` bigint(20) NOT NULL COMMENT "历史记录主键id",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `AccountId` bigint(20) NOT NULL COMMENT "用户id",
  `SeriesId` bigint(20) NOT NULL COMMENT "剧id",
  `EpisId` bigint(20) NOT NULL COMMENT "集id",
  `WatchStamp` int(11) NOT NULL COMMENT "观看时间戳",
  `EpisNum` int(11) NULL COMMENT "集数",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`, `CreateTime`)
COMMENT "短剧-用户观看短剧记录表"
DISTRIBUTED BY HASH(`Id`, `CreateTime`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AccountId, SeriesId, EpisId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
