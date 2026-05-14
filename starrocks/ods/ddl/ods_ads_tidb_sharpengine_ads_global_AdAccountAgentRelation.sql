CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `AgentId` bigint(20) NULL COMMENT "",
  `Account` varchar(128) NULL COMMENT "",
  `AccountSource` int(11) NULL COMMENT "账号来源",
  `Level` int(11) NULL COMMENT "代理商等级",
  `CreatedTime` datetime NULL COMMENT "创建时间",
  `UpdatedTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "代理商"
DISTRIBUTED BY HASH(`Id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
