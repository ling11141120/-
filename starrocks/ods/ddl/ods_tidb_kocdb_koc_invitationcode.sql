CREATE TABLE `ods_tidb_kocdb_koc_invitationcode` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `Code` varchar(50) NULL COMMENT "邀请码",
  `StarId` bigint(20) NULL COMMENT "达人ID",
  `UserId` varchar(128) NULL COMMENT "用户id",
  `ChangeLimit` int(11) NULL COMMENT "已经换绑次数",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "koc邀请码表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
