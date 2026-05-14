CREATE TABLE `ods_tidb_short_video_admin_series_qa` (
  `SeriesId` bigint(20) NOT NULL COMMENT "剧集id",
  `Status` varchar(100) NULL COMMENT "状态（1、开始审核 2、qa完成 3、qc完成）",
  `BeginTime` datetime NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `QaUser` varchar(100) NULL COMMENT "qa 用户",
  `QcUser` varchar(100) NULL COMMENT "qc 用户",
  `QaPassTime` datetime NULL COMMENT "qa 通过时间",
  `QcPassTime` datetime NULL COMMENT "qc 通过时间",
  `UpdateTime` varchar(100) NULL COMMENT "最后修改时间",
  `sr_updatetime` datetime NULL COMMENT "ods同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
) ENGINE=OLAP 
PRIMARY KEY(`SeriesId`)
COMMENT "剧集qa表,author 232618"
DISTRIBUTED BY HASH(`SeriesId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
