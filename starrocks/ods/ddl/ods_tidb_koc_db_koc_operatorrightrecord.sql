CREATE TABLE `ods_tidb_koc_db_koc_operatorrightrecord` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `OperatorId` varchar(600) NULL COMMENT "商务ID",
  `RightId` bigint(20) NULL COMMENT "达人、机构id",
  `Type` int(11) NULL COMMENT "0达人 1机构",
  `Status` int(11) NULL COMMENT "0停止 1启用",
  `BeginTime` datetime NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `CreatorUid` varchar(600) NULL COMMENT "创建人账号ID",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "商务关系id映射信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
