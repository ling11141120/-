CREATE TABLE `ads_syncbi_book_newcid_rank_info` (
  `dt` date NOT NULL COMMENT "数据更新分区",
  `time_types` int(11) NOT NULL COMMENT "1：昨日数据 2：历史数据",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `book_name` varchar(65533) NULL COMMENT "书籍名称",
  `introduce` varchar(65533) NULL COMMENT "书籍简介",
  `newc_id` int(11) NULL COMMENT "分类id",
  `newc_name` varchar(65533) NULL COMMENT "分类名称",
  `sign_type` int(11) NULL COMMENT "独家：0 买断， 1 A签；非独家：2 B签； 未签约：-1",
  `etl_time` datetime NULL COMMENT "etl数据清洗时间",
  `build_time` datetime NULL COMMENT "书籍上架时间",
  `author_name` varchar(200) NULL COMMENT "作者",
  `tag` varchar(3000) NULL COMMENT "tag"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `time_types`, `language_id`, `book_id`)
COMMENT "各语言书籍分类排行数据"
DISTRIBUTED BY HASH(`dt`, `time_types`, `language_id`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);