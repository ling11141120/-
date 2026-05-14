CREATE TABLE `ods_mysql_zhangzhong_xzz_BookEditorRight` (
  `BookId` bigint(20) NOT NULL COMMENT "书籍Id",
  `UserId` bigint(20) NOT NULL COMMENT "责编帐号",
  `Id` bigint(20) NOT NULL COMMENT "自增Id",
  `EditorType` int(11) NULL COMMENT "编辑类型",
  `InUse` int(11) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "新增时间"
) ENGINE=OLAP 
PRIMARY KEY(`BookId`, `UserId`)
COMMENT "新掌中--书籍责任编辑表"
DISTRIBUTED BY HASH(`BookId`, `UserId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, UserId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
