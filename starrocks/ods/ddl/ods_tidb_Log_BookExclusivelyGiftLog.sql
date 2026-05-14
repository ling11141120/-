CREATE TABLE `ods_tidb_Log_BookExclusivelyGiftLog` (
  `ProductId` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "",
  `Num` int(11) NULL COMMENT "",
  `Type` int(11) NULL COMMENT "",
  `Source` varchar(1600) NULL COMMENT "",
  `BookId` bigint(20) NULL COMMENT "",
  `UserId` bigint(20) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `AppId` int(11) NULL COMMENT "",
  `SourceKey` varchar(900) NULL COMMENT "",
  `ExpireTime` datetime NULL COMMENT "",
  `sr_createtime` datetime NULL COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`ProductId`, `Id`)
DISTRIBUTED BY HASH(`ProductId`, `Id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, UserId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
