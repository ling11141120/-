CREATE TABLE `ods_tidb_shuangwen_xx_bookeditorright` (
  `ProductId` smallint(6) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `EditorType` int(11) NULL COMMENT "编辑者类型",
  `Language` int(11) NULL COMMENT "语言",
  `CreateTime` datetime NULL COMMENT "新增时间",
  `RowVersion` bigint(20) NULL COMMENT "版本号",
  `InUse` int(11) NULL COMMENT "是否使用中 1 是 0否",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "sr数据更新时间",
  INDEX index_ProductId (`ProductId`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`ProductId`, `Id`)
COMMENT "编辑网编信息表"
DISTRIBUTED BY HASH(`ProductId`, `Id`) BUCKETS 8 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, UserId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
