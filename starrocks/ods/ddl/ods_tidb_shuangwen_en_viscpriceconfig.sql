CREATE TABLE `ods_tidb_shuangwen_en_viscpriceconfig` (
  `Id` int(11) NOT NULL COMMENT "主键",
  `Price` decimal(18, 2) NOT NULL COMMENT "单价",
  `BookType` int(11) NOT NULL COMMENT "书籍类型",
  `ToLanguage` int(11) NOT NULL COMMENT "语言",
  `EnableTime` datetime NOT NULL COMMENT "启用日期",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `CreateUser` varchar(50) NULL COMMENT "创建人",
  `DelStatus` int(11) NULL COMMENT "是否删除",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "千字价配置表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
