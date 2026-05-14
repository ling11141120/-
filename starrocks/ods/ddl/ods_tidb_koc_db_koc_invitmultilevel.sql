CREATE TABLE `ods_tidb_koc_db_koc_invitmultilevel` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `StarId` bigint(20) NULL COMMENT "达人id",
  `MemberId` bigint(20) NULL COMMENT "佣兵ID",
  `InstitutionId` bigint(20) NULL COMMENT "机构ID",
  `CreateTime` datetime NULL COMMENT "绑定时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "KOC邀请关系表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
