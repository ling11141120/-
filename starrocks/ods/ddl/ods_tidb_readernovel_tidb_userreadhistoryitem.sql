CREATE TABLE `ods_tidb_readernovel_tidb_userreadhistoryitem` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `LastReadTime` datetime NULL COMMENT "最近一次阅读时间",
  `Pid` bigint(20) NOT NULL COMMENT "用户id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
DUPLICATE KEY(`product_id`, `BookId`, `LastReadTime`)
DISTRIBUTED BY HASH(`product_id`, `BookId`, `Pid`) BUCKETS 6 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, Pid",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
