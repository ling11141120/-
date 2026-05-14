CREATE TABLE `ods_tidb_readernovel_tidb_mutexconfigbook` (
  `ProductId` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `BookId` bigint(20) NULL COMMENT "书籍ID",
  `BookName` varchar(255) NULL COMMENT "书籍名称",
  `ConfigId` bigint(20) NULL COMMENT "配置ID",
  `Language` int(11) NULL COMMENT "语言",
  `IsMainPush` int(11) NULL COMMENT "是否主推",
  `BookType` int(11) NULL COMMENT "书籍类型",
  `IsDelete` int(11) NULL COMMENT "是否删除",
  `SyncLanguage` varchar(255) NULL COMMENT "同步语言",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `row_update_time` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_ProductId (`ProductId`) USING BITMAP COMMENT 'index_ProductId'
) ENGINE=OLAP 
PRIMARY KEY(`ProductId`, `Id`)
COMMENT "书籍互斥表"
DISTRIBUTED BY HASH(`ProductId`, `Id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "row_update_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
