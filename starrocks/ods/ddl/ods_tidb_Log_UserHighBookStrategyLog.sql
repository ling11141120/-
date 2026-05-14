CREATE TABLE `ods_tidb_Log_UserHighBookStrategyLog` (
  `ProductId` int(11) NOT NULL COMMENT "产品ID",
  `Id` bigint(20) NOT NULL COMMENT "各个海外环境数据库中的主键ID",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `Type` int(11) NULL COMMENT "类型",
  `StrategyId` bigint(20) NULL COMMENT "千字价格策略id",
  `ChapterId` bigint(20) NULL COMMENT "章节id",
  `ChapterNum` bigint(20) NULL COMMENT "章节序号",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `AppId` int(11) NULL COMMENT "AppId",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`ProductId`, `Id`)
COMMENT "用户嗨点策略"
DISTRIBUTED BY HASH(`ProductId`, `Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, UserId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
