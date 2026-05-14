CREATE TABLE `ods_tidb_readernovel_tidb_edm_Mail_CallBak_click` (
  `Id` int(11) NOT NULL COMMENT "编号id",
  `Lang` varchar(65533) NULL COMMENT "语言",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `Url` varchar(65533) NULL COMMENT "点击链接",
  `AddTime` varchar(65533) NULL COMMENT "添加时间",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "邮件召回点击"
DISTRIBUTED BY HASH(`Id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AddTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
