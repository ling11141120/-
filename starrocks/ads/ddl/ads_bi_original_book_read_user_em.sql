CREATE TABLE `ads_bi_original_book_read_user_em` (
  `years` int(11) NOT NULL COMMENT "年",
  `qtypes` int(11) NOT NULL COMMENT "1：按月的",
  `dt` int(11) NOT NULL COMMENT "月份",
  `site_id` int(11) NOT NULL COMMENT "书籍语言id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `counts` int(11) NULL COMMENT "次数",
  `etl_time` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`years`, `qtypes`, `dt`, `site_id`, `book_id`, `user_id`)
COMMENT "服务端编辑后台-按月、原创、原创拆章书籍有阅读的用户"
DISTRIBUTED BY HASH(`years`, `qtypes`, `dt`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);