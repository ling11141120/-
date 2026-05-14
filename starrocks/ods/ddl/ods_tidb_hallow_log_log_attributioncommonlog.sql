CREATE TABLE `ods_tidb_hallow_log_log_attributioncommonlog` (
  `dt` date NOT NULL COMMENT "分区日期",
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `Action` varchar(1536) NULL COMMENT "来源的action",
  `MT` int(11) NULL COMMENT "mt",
  `Core` int(11) NULL COMMENT "Core",
  `UserId` bigint(20) NULL COMMENT "用户Id",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `F0` bigint(20) NULL COMMENT "F0",
  `F1` bigint(20) NULL COMMENT "F1",
  `F2` bigint(20) NULL COMMENT "F2",
  `F3` bigint(20) NULL COMMENT "F3",
  `F4` bigint(20) NULL COMMENT "F4",
  `F5` bigint(20) NULL COMMENT "F5",
  `F6` bigint(20) NULL COMMENT "F6",
  `F7` bigint(20) NULL COMMENT "F7",
  `F8` bigint(20) NULL COMMENT "F8",
  `F9` bigint(20) NULL COMMENT "F9",
  `S0` varchar(65533) NULL COMMENT "S0",
  `S1` varchar(65533) NULL COMMENT "S1",
  `S2` varchar(65533) NULL COMMENT "S2",
  `S3` varchar(65533) NULL COMMENT "S3",
  `S4` varchar(65533) NULL COMMENT "S4",
  `S5` varchar(65533) NULL COMMENT "S5",
  `S6` varchar(65533) NULL COMMENT "S6",
  `S7` varchar(65533) NULL COMMENT "S7",
  `S8` varchar(65533) NULL COMMENT "S8",
  `S9` varchar(65533) NULL COMMENT "S9",
  `sr_createtime` datetime NULL COMMENT "starrocks入库时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `Id`)
COMMENT "广告归因通用日志表"
PARTITION BY date_trunc('month', dt)
DISTRIBUTED BY HASH(`dt`, `Id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
