CREATE TABLE `ods_tidb_short_video_series_type` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `Name` varchar(100) NOT NULL COMMENT "分类名称",
  `NameKey` varchar(100) NOT NULL COMMENT "分类名称Key",
  `Status` tinyint(4) NOT NULL COMMENT "状态 0禁用 1启用",
  `CreateUser` varchar(100) NULL COMMENT "创建者",
  `UpdateUser` varchar(100) NULL COMMENT "修改者",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_updatetime` datetime NULL COMMENT "ods同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "短剧分类信息表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
