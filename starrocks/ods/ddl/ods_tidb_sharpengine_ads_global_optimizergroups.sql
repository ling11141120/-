CREATE TABLE `ods_tidb_sharpengine_ads_global_optimizergroups` (
  `Id` int(11) NOT NULL COMMENT "主键id",
  `Code` varchar(65533) NOT NULL COMMENT "分组名/优化师名",
  `Enable` int(11) NOT NULL COMMENT "1启用0禁用",
  `ParentId` int(11) NOT NULL COMMENT "父分组id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "优化师表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
