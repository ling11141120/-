CREATE TABLE `ods_tidb_readernovel_tidb_tag_operation_position` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `ActivityId` int(11) NOT NULL COMMENT "活动id",
  `PositionName` varchar(128) NOT NULL COMMENT "触达位名称",
  `ActionId` int(11) NOT NULL COMMENT "策略Id",
  `GroupIds` varchar(256) NULL COMMENT "人群包Id",
  `ExcludeGroupIds` varchar(256) NULL COMMENT "剔除人群包Id",
  `CarrierType` int(11) NOT NULL COMMENT "载体类型",
  `Status` int(11) NOT NULL COMMENT "状态 0关闭，1开启",
  `Field` varchar(2048) NULL COMMENT "字段",
  `OperationUser` varchar(128) NOT NULL COMMENT "操作用户",
  `OperationType` int(11) NOT NULL COMMENT "操作类型（0新增，1修改,2移除）",
  `CreateTime` datetime NOT NULL COMMENT "操作时间",
  `AssociationId` bigint(20) NOT NULL COMMENT "关联ID",
  `OperationStatus` int(11) NULL COMMENT "操作日志状态（0有效，1失效）",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "点位日志"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
