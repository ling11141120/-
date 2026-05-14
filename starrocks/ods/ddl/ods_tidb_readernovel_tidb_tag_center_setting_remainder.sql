CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_setting_remainder` (
  `dt` datetime NOT NULL COMMENT "日期",
  `Id` int(11) NOT NULL COMMENT "",
  `SettingId` int(11) NULL COMMENT "",
  `StartNumber` int(11) NULL COMMENT "",
  `EndNumber` int(11) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `sr_createtime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime, SettingId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
