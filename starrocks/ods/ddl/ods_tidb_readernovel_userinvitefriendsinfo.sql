CREATE TABLE `ods_tidb_readernovel_userinvitefriendsinfo` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `Pid` bigint(20) NOT NULL COMMENT "用户id",
  `JifenNum` int(11) NULL COMMENT "积分总数",
  `Type` int(11) NULL COMMENT "1:有邀请阅读时长任务",
  `InviteUserId` bigint(20) NULL COMMENT "被邀请人",
  `CreateTime` datetime NOT NULL COMMENT "邀请时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "阅读-邀请好友成功记录表"
DISTRIBUTED BY HASH(`product_id`, `Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
