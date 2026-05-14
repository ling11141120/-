CREATE TABLE `ods_tidb_readernovel_tidb_xx_worldcupassistrecord` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `ChangeType` int(11) NULL COMMENT "助力值变更类型",
  `ChangeAssistValue` int(11) NULL COMMENT "变更助力值",
  `ChangeTime` datetime NULL COMMENT "变更时间",
  `RelationData` varchar(955) NULL COMMENT "关联数据 有赛事 值为赛事no",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
