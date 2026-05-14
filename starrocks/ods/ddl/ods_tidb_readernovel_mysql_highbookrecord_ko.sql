CREATE TABLE `ods_tidb_readernovel_mysql_highbookrecord_ko` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` int(11) NOT NULL COMMENT "自增id",
  `BookId` bigint(20) NOT NULL COMMENT "书籍id",
  `HighChapterIds` varchar(65533) NULL COMMENT "high点章节",
  `AdviseChapterIds` varchar(65533) NULL COMMENT "建议章节",
  `FreeChapterNum` int(11) NULL COMMENT "免费章节数",
  `BeforFreeChapterNum` int(11) NULL COMMENT "之前免费章节数",
  `StartTime` datetime NOT NULL COMMENT "开始生效时间",
  `EndTime` datetime NOT NULL COMMENT "结束时间",
  `Platform` int(11) NOT NULL COMMENT "终端",
  `ModifId` varchar(65533) NULL COMMENT "修改id",
  `Modifier` varchar(65533) NULL COMMENT "修改人",
  `ModifyTime` datetime NULL COMMENT "修改时间",
  `CreateId` varchar(65533) NOT NULL COMMENT "创建人id",
  `Creator` varchar(65533) NOT NULL COMMENT "创建人",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `IsDelete` int(11) NULL DEFAULT "0" COMMENT "",
  `row_update_time` datetime NULL COMMENT "更新时间",
  `SyncLanguage` varchar(65533) NULL COMMENT "同步语言",
  `Language` int(11) NULL COMMENT "源语言",
  `Core` varchar(65533) NULL COMMENT "core",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "high点测试，创建higi点信息配置表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
