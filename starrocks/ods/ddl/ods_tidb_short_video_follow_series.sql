CREATE TABLE `ods_tidb_short_video_follow_series` (
  `Id` bigint(20) NOT NULL COMMENT "追剧表主键",
  `AccountId` bigint(20) NOT NULL COMMENT "用户主键",
  `SeriesId` bigint(20) NULL COMMENT "剧集ID ",
  `CreateTime` datetime NULL COMMENT "",
  `regionId` smallint(6) NULL COMMENT "归属区域 id，1：香港，2：北美；",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧-添加追剧"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
