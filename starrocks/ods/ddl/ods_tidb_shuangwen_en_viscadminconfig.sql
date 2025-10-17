CREATE TABLE ods.`ods_tidb_shuangwen_en_viscadminconfig` (
  `Id` int(11) NOT NULL COMMENT "自增id",
  `AccountName` varchar(500) NULL COMMENT "用户名",
  `SiteId` int(11) NOT NULL COMMENT "站点id",
  `ModifyTime` datetime NOT NULL COMMENT "修改时间",
  `RowVersion` bigint(20) NULL COMMENT "数据修改版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "项管信息表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);