CREATE TABLE `ods_tidb_readernovel_tidb_tag_operation_pricing` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `PricingId` int(11) NOT NULL COMMENT "方案Id",
  `PricingName` varchar(128) NOT NULL COMMENT "方案名称",
  `GroupIds` varchar(256) NULL COMMENT "人群包Id",
  `ExcludeGroupIds` varchar(256) NULL COMMENT "剔除人群包Id",
  `Price` decimal(11, 0) NOT NULL COMMENT "系统价格",
  `BeginTime` datetime NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `Field` varchar(2048) NULL COMMENT "字段",
  `OperationUser` varchar(128) NOT NULL COMMENT "操作用户",
  `OperationType` int(11) NOT NULL COMMENT "操作类型（0新增，1修改）",
  `CreateTime` datetime NOT NULL COMMENT "操作时间",
  `AssociationId` bigint(20) NOT NULL COMMENT "关联ID",
  `OperationStatus` int(11) NULL COMMENT "操作日志状态（0有效，1失效）",
  `IsFixedPrice` tinyint(4) NOT NULL COMMENT "一口价",
  `Coefficient` decimal(4, 2) NOT NULL COMMENT "系数",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "系统价格"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
