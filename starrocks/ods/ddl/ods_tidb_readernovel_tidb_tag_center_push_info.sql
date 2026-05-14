CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_push_info` (
  `Id` int(11) NOT NULL COMMENT "Id",
  `PushId` int(11) NOT NULL COMMENT "",
  `ParentId` int(11) NOT NULL COMMENT "父级Id",
  `ActionId` int(11) NOT NULL COMMENT "策略Id",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `ActionName` varchar(128) NOT NULL COMMENT "策略名称",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "tag后台,push活动配置明细表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
