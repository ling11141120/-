CREATE TABLE `ods_tidb_short_video_account_like` (
  `Id` bigint(20) NOT NULL COMMENT "点赞表主键ID",
  `AccountId` bigint(20) NOT NULL COMMENT "用户id",
  `EpisId` bigint(20) NOT NULL COMMENT "集数id",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `IsDelete` tinyint(4) NULL DEFAULT "0" COMMENT "逻辑删除字段",
  `regionId` smallint(6) NULL DEFAULT "1" COMMENT "归属区域 id，1：香港，2：北美；",
  `SeriesId` bigint(20) NULL COMMENT "剧id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海外短剧-用户点赞表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
