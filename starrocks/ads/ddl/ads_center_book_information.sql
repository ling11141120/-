CREATE TABLE `ads_center_book_information` (
  `bookid` bigint(20) NOT NULL COMMENT "书籍ID",
  `Score` int(11) NOT NULL COMMENT "评级",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`bookid`)
DISTRIBUTED BY HASH(`bookid`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);