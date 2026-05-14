CREATE TABLE `ods_tidb_short_video_center_schema_channel` (
  `Id` bigint(20) NOT NULL COMMENT "主键Id",
  `SchemeId` bigint(20) NULL COMMENT "方案Id",
  `ChannelId` bigint(20) NULL COMMENT "频道Id",
  `Sort` int(11) NULL COMMENT "位序",
  `IsDefault` int(11) NULL COMMENT "是否为默认展示：0否 1是",
  `DelStatus` int(11) NULL COMMENT "是否删除：0否 1是",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `isRed` int(11) NULL COMMENT "是否设置红点:0否 1是",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "方案与频道关联表信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "SchemeId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
