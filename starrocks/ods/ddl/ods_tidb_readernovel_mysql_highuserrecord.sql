CREATE TABLE `ods_tidb_readernovel_mysql_highuserrecord` (
  `dt` date NOT NULL COMMENT "createtime 分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `Message` varchar(65533) NULL COMMENT "信息",
  `ChapterIndex` int(11) NULL COMMENT "章节序号",
  `ChapterId` bigint(20) NULL COMMENT "章节id",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `Id`)
COMMENT "high点测试，用户记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
