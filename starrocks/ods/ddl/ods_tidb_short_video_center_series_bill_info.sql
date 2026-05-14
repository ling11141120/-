CREATE TABLE `ods_tidb_short_video_center_series_bill_info` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `BillId` bigint(20) NOT NULL COMMENT "书单id(剧目id)",
  `Weight` int(11) NOT NULL COMMENT "权重",
  `BeginTime` datetime NULL COMMENT "推荐开始时间",
  `EndTime` datetime NULL COMMENT "推荐结束时间",
  `LangId` int(11) NOT NULL COMMENT "语言",
  `DelStatus` tinyint(4) NOT NULL COMMENT "是否删除",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "更新时间",
  `SeriesId` bigint(20) NOT NULL COMMENT "剧集id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_LangId (`LangId`) USING BITMAP COMMENT 'index_LangId'
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海外短剧-剧目单明细"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BillId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
