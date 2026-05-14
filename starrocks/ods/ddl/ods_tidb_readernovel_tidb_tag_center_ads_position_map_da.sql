CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_ads_position_map_da` (
  `Id` int(11) NOT NULL COMMENT "主键",
  `AdShowTypeName` varchar(755) NOT NULL COMMENT "广告类型名称",
  `AdShowType` int(11) NOT NULL COMMENT "广告类型Id",
  `AdPositionName` varchar(755) NOT NULL COMMENT "广告位置名称",
  `AdPosition` int(11) NOT NULL COMMENT "广告位置",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "修改时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "阅读app内-广告位置映射表 author:195666"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
