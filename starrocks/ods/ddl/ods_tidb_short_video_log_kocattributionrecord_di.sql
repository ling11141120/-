CREATE TABLE `ods_tidb_short_video_log_kocattributionrecord_di` (
  `Id` bigint(20) NOT NULL COMMENT "id",
  `Pid` bigint(20) NOT NULL COMMENT "用户id",
  `Mt` int(11) NULL COMMENT "mt",
  `Core` int(11) NULL COMMENT "core",
  `Chl` varchar(65533) NULL COMMENT "渠道",
  `CurrentLanguage` int(11) NULL COMMENT "语言",
  `BeginTime` datetime NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `ResourceId` bigint(20) NULL COMMENT "书籍id",
  `KocText` varchar(65533) NULL COMMENT "口令",
  `AdId` varchar(65533) NULL COMMENT "adid",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧-用户koc归因记录"
DISTRIBUTED BY HASH(`Id`) BUCKETS 6 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "Pid",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
