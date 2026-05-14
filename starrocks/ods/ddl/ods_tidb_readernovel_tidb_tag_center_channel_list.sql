CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_channel_list` (
  `Id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT "",
  `ChannelId` int(11) NOT NULL COMMENT "频道Id",
  `ListId` int(11) NOT NULL COMMENT "榜单Id",
  `Sort` int(11) NOT NULL COMMENT "排序",
  `CreateTime` datetime NOT NULL COMMENT "",
  `UpdateTime` datetime NOT NULL COMMENT "",
  `DelStatus` int(11) NOT NULL COMMENT "是否删除",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
