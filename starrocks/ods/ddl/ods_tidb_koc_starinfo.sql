CREATE TABLE `ods_tidb_koc_starinfo` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `InstitutionId` bigint(20) NULL COMMENT "机构ID",
  `StarName` varchar(65533) NULL COMMENT "达人名称",
  `UserId` varchar(65533) NULL COMMENT "登录账号表对应的UserId",
  `StarStatus` int(11) NULL COMMENT "状态 0=禁用|1=启用",
  `StarRemark` varchar(65533) NULL COMMENT "备注",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `Creator` varchar(65533) NULL COMMENT "创建人名称",
  `CreatorUid` varchar(65533) NULL COMMENT "创建人账号ID",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `Updater` varchar(65533) NULL COMMENT "创建人名称",
  `UpdaterUid` varchar(65533) NULL COMMENT "更新人账号ID",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "KOC达人信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
