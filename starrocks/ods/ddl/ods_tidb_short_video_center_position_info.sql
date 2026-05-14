CREATE TABLE `ods_tidb_short_video_center_position_info` (
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `PositionId` bigint(20) NULL COMMENT "资源位Id",
  `ParentId` bigint(20) NULL COMMENT "活动Id",
  `ActionId` bigint(20) NULL COMMENT "活动策略Id	",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `ActionName` varchar(200) NULL COMMENT "活动策略名称",
  `IsRemove` int(11) NULL COMMENT "是否删除 1 是，0否",
  `AppType` int(11) NULL COMMENT "应用类型： 1：短剧，2：阅读",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧-资源位与活动策略关联表；author：232618"
DISTRIBUTED BY HASH(`Id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
