CREATE TABLE `ods_tidb_short_video_repel_group` (
  `Id` bigint(20) NOT NULL COMMENT "唯一ID",
  `Language` int(11) NULL COMMENT "语言",
  `Remark` varchar(100) NULL COMMENT "备注信息",
  `IsDelete` tinyint(4) NULL COMMENT "是否删除，0：正常；1：删除。",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `sr_updatetime` datetime NULL COMMENT "ods同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "短剧集互斥组 author：232618"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
