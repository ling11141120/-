CREATE TABLE `ods_tidb_shuangwen_book_channel_income_config` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `BookId` int(11) NOT NULL COMMENT "书籍id",
  `SiteId` int(11) NOT NULL COMMENT "语言id",
  `Language` int(11) NULL COMMENT "语言",
  `DelFlag` int(11) NULL COMMENT "DelFlag",
  `StartTime` datetime NULL COMMENT "生效时间",
  `ChannelBookId` int(11) NOT NULL COMMENT "书籍渠道id",
  `AuthorId` bigint(20) NOT NULL COMMENT "作者id",
  `Rate` double NOT NULL COMMENT "Rate",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `RowVersion` bigint(20) NULL COMMENT "更新版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`, `BookId`, `SiteId`)
COMMENT "书籍渠道收入表"
DISTRIBUTED BY HASH(`product_id`) BUCKETS 4 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "SiteId, BookId, product_id, Id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
