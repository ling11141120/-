CREATE TABLE `dim_read_bookshelftouser` (
  `Productid` int(11) NOT NULL COMMENT "产品id",
  `UserId` bigint(20) NOT NULL COMMENT "用户id",
  `BookId` bigint(20) NOT NULL COMMENT "书籍id",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`Productid`, `UserId`, `BookId`)
COMMENT "用户云书架记录"
DISTRIBUTED BY HASH(`Productid`, `UserId`, `BookId`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, UserId, Productid",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);