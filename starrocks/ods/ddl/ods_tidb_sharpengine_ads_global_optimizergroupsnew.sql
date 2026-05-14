CREATE TABLE `ods_tidb_sharpengine_ads_global_optimizergroupsnew` (
  `Id` int(11) NOT NULL COMMENT "主键id",
  `Code` varchar(100) NOT NULL COMMENT "工号",
  `Enable` int(11) NOT NULL COMMENT "是否有效",
  `ParentId` int(11) NOT NULL COMMENT "组id",
  `ProjectCode` int(11) NULL COMMENT "项目代码",
  `GroupType` int(11) NULL COMMENT "组类型",
  `IsGroupLeader` int(11) NULL COMMENT "1 组长 0 组员",
  `SourceChl` varchar(65533) NULL COMMENT "媒体",
  `CodeValue` varchar(100) NULL COMMENT "优化师组Code值",
  `SubGroupType` int(11) NULL COMMENT "子组类型 1编制 2师徒",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
DUPLICATE KEY(`Id`, `Code`)
COMMENT "优化师组配置"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
