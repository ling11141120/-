CREATE TABLE `ods_content_book_parent_book_relation` (
  `ProductId` bigint(20) NOT NULL COMMENT "产品ID",
  `BookId` bigint(20) NOT NULL COMMENT "书籍ID",
  `ParentBookId` bigint(20) NOT NULL COMMENT "父级书ID",
  `RootParentBookId` bigint(20) NOT NULL COMMENT "根父级书ID",
  `LanguageId` int(11) NOT NULL COMMENT "产品语言",
  `CreateTime` datetime NOT NULL COMMENT "数据生成时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "SR数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "SR数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`ProductId`, `BookId`)
COMMENT "内容域--拆章书与源书的关系表"
DISTRIBUTED BY HASH(`ProductId`, `BookId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "true",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
