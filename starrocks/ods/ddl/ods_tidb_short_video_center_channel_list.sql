CREATE TABLE `ods_tidb_short_video_center_channel_list` (
  `Id` bigint(20) NOT NULL COMMENT "主键Id",
  `ChannelId` bigint(20) NULL COMMENT "频道Id",
  `ListId` bigint(20) NULL COMMENT "榜单Id",
  `Sort` int(11) NULL COMMENT "排序",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `DelStatus` int(11) NULL COMMENT "是否删除：0否 1是",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "频道与榜单关联表信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "ChannelId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
