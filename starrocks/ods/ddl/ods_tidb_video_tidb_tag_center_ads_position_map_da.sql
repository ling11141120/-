CREATE TABLE `ods_tidb_video_tidb_tag_center_ads_position_map_da` (
  `Id` int(11) NOT NULL COMMENT "主键id",
  `AdShowTypeName` varchar(65533) NULL COMMENT "广告类型名称",
  `AdShowType` int(11) NULL COMMENT "广告类型Id",
  `AdPositionName` varchar(65533) NULL COMMENT "广告位置名称",
  `AdPosition` int(11) NULL COMMENT "广告位置",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "短剧app内-广告位置映射表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
