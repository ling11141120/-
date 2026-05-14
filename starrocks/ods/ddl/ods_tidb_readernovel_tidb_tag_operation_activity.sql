CREATE TABLE `ods_tidb_readernovel_tidb_tag_operation_activity` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `ActivityId` int(11) NOT NULL COMMENT "活动Id",
  `ActivityType` int(11) NOT NULL COMMENT "活动类型",
  `ActionId` int(11) NOT NULL COMMENT "策略Id",
  `BeginTime` datetime NOT NULL COMMENT "开始时间",
  `EndTime` datetime NOT NULL COMMENT "结束时间",
  `ActivityName` varchar(128) NOT NULL COMMENT "活动名称",
  `ActionName` varchar(128) NOT NULL COMMENT "策略名称",
  `GroupIds` varchar(256) NOT NULL COMMENT "人群包Id",
  `Field` varchar(2048) NULL COMMENT "修改字段",
  `OperationUser` varchar(128) NOT NULL COMMENT "修改用户",
  `OperationType` int(11) NOT NULL COMMENT "操作类型（新增0，修改1,删除2）",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `AssociationId` bigint(20) NOT NULL COMMENT "关联Id",
  `OperationStatus` int(11) NOT NULL COMMENT "操作日志状态（0有效，1失效）",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "活动载体"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
