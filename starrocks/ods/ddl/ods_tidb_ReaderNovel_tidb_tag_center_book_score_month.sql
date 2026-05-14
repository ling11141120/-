CREATE TABLE `ods_tidb_ReaderNovel_tidb_tag_center_book_score_month` (
  `Id` int(11) NOT NULL COMMENT "id",
  `BookId` bigint(20) NOT NULL COMMENT "书籍ID",
  `StatMonth` datetime NOT NULL COMMENT "月份",
  `ScoreType` int(11) NOT NULL COMMENT "未评级 = 0, S = 1, A = 2, B = 3, C = 4",
  `UpdateTime` datetime NOT NULL COMMENT "更新时间",
  `LangId` int(11) NOT NULL COMMENT "语言ID",
  `ScoreNum` decimal(18, 2) NULL COMMENT "",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "月度评级"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
