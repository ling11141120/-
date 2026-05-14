CREATE TABLE `ods_tidb_shuangwen_en_customchapterplus` (
  `Id` int(11) NOT NULL COMMENT "主键id",
  `BookId` bigint(20) NOT NULL COMMENT "书籍id",
  `EnableTime` datetime NOT NULL COMMENT "生效时间",
  `StartNum` int(11) NOT NULL COMMENT "日更配置数量",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `CreateUser` varchar(50) NULL COMMENT "创建者",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `UpdateUser` varchar(50) NULL COMMENT "更新者",
  `DelStatus` int(11) NOT NULL COMMENT "是否删除",
  `RowVersion` bigint(20) NULL COMMENT "数据版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "定制文配置表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
