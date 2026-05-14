CREATE TABLE `ods_tidb_short_video_admin_source_series_1` (
  `SeriesId` bigint(20) NOT NULL DEFAULT "0" COMMENT "剧集ID",
  `SeriesName` varchar(255) NULL COMMENT "剧集名称",
  `Language` int(11) NULL COMMENT "语言id",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `IsComplete` tinyint(4) NULL DEFAULT "1" COMMENT "分集是否完整 1 完整 0 缺失",
  `IsDelete` tinyint(4) NULL DEFAULT "0" COMMENT "是否删除 1 删除 0 未删除",
  `SeriesCode` varchar(100) NULL COMMENT "代码",
  `CooperateType` int(11) NULL COMMENT "作方式(1买断、2分成、3保底分成)",
  `RightsHolderId` bigint(20) NULL COMMENT "版权方Id",
  `ShareRatio` decimal(18, 2) NULL DEFAULT "0.00" COMMENT "分成比例",
  `BeginDate` date NULL COMMENT "开始日期",
  `EndDate` date NULL COMMENT "结束日期",
  `IsHidden` int(11) NULL DEFAULT "1" COMMENT "是否隐藏 1是 0不是",
  `RelationshipsUrl` varchar(65533) NULL COMMENT "人物关系",
  `LangIds` varchar(65533) NULL COMMENT "结算语言id,逗号分隔",
  `coef` decimal(18, 2) NULL COMMENT "分成系数",
  `IsMain` tinyint(4) NULL COMMENT "是否是主剧",
  `MainSeriesId` bigint(20) NULL COMMENT "主原始剧id",
  `AllEpis` int(11) NULL COMMENT "总集数",
  `HasSubTitle` tinyint(4) NULL COMMENT "是否有字幕",
  `LocalType` int(11) NULL COMMENT "类型 1外文剧 2 中文剧",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "ods同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
) ENGINE=OLAP 
PRIMARY KEY(`SeriesId`)
COMMENT "海外短剧源表"
DISTRIBUTED BY HASH(`SeriesId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
