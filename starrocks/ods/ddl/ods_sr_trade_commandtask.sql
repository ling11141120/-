CREATE TABLE `ods_sr_trade_commandtask` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `ClassType` varchar(65533) NULL COMMENT "",
  `Args` varchar(65533) NULL COMMENT "",
  `ScheduleTime` datetime NULL COMMENT "",
  `Status` int(11) NULL COMMENT "",
  `ExecCount` int(11) NULL COMMENT "",
  `ExecTime` datetime NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海阅--订单退款记录"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "ZSTD"
);
