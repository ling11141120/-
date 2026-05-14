CREATE TABLE `ads_SyncBi_update_status` (
  `Id` int(11) NOT NULL COMMENT "主键id",
  `TableName` varchar(50) NOT NULL COMMENT "表名",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  INDEX index_UpdateTime (`UpdateTime`) USING BITMAP
) ENGINE=OLAP 
PRIMARY KEY(`Id`, `TableName`)
COMMENT "更新状态表"
DISTRIBUTED BY HASH(`Id`, `TableName`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);