CREATE TABLE `ods_tidb_short_video_admin_video_mapping` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `RightsHolderId` bigint(20) NULL COMMENT "版权方id  海剧或者国剧视频不归属这个版权方，该数据自动无效",
  `SourceSeriesId` bigint(20) NULL COMMENT "海剧视频id",
  `CnSourceSeriesId` bigint(20) NULL COMMENT "国剧视频id",
  `CreateUserInfo` varchar(65533) NULL COMMENT "创建人",
  `UpdateUserInfo` varchar(65533) NULL COMMENT "修改人",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `IsDelete` tinyint(4) NULL COMMENT "是否删除",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国剧海剧映射表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "SourceSeriesId, CnSourceSeriesId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
