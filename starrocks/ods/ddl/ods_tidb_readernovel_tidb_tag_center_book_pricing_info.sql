CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_book_pricing_info` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `BookId` bigint(20) NOT NULL COMMENT "书籍Id",
  `PricingId` int(11) NOT NULL COMMENT "定价配置Id",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `IsDelete` tinyint(4) NOT NULL COMMENT "是否删除",
  `sr_createtime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
