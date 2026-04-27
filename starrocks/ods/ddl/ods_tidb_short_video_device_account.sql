CREATE TABLE ods.`ods_tidb_short_video_device_account` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `DeviceId` varchar(300) NOT NULL COMMENT "设备id",
  `AccountId` bigint(20) NULL COMMENT "账户id",
  `UpdateTime` datetime NULL COMMENT "上次变更的时间",
  `IsBind` int(11) NULL DEFAULT "0" COMMENT "是否被绑定 0 否 1 是",
  `IsDelete` int(11) NULL DEFAULT "0" COMMENT "逻辑删除字段",
  `regionId` int(11) NULL DEFAULT "1" COMMENT "归属区域 id，1：香港，2：北美；",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 70
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);