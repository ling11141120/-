CREATE TABLE `ods_tidb_short_video_admin_subtitle_trans_job` (
  `Id` bigint(20) NOT NULL COMMENT "唯一ID",
  `SeriesId` bigint(20) NOT NULL COMMENT "剧集id",
  `LangId` int(11) NULL COMMENT "语言Id",
  `Status` int(11) NULL COMMENT "状态 1 待翻译、2 翻译中、3 翻译完成",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `TranslangId` int(11) NULL COMMENT "翻译中心语言  0中文，322英语，375西语，409葡语，410法语，418俄语，419日语，414印尼语，433泰语，436韩语",
  `TransJobId` bigint(20) NULL COMMENT "翻译中心任务id(用于后续小语种任务繁体)",
  `SourceTransJobId` bigint(20) NULL COMMENT "原始cn->en的任务id",
  `JobLevel` int(11) NULL DEFAULT "3" COMMENT "任务等级(1 加急,2 P0,3 P1,4 P2)",
  `IsCustom` int(11) NOT NULL DEFAULT "0" COMMENT "是否自定义  1是，0否",
  `IsRefinement` int(11) NOT NULL DEFAULT "0" COMMENT "是否精修  1是，0否",
  `sr_updatetime` datetime NULL COMMENT "ods同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "翻译任务表 author:232618"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
