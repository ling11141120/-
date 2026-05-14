CREATE TABLE `ads_sr_consume_top6_book_mi` (
  `dt` date NOT NULL COMMENT "日期",
  `sort_num` int(11) NOT NULL COMMENT "排序",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `book_id_cn` bigint(20) NULL COMMENT "中文书籍id",
  `book_name` varchar(500) NULL COMMENT "书籍名称",
  `cover_src` varchar(65533) NULL COMMENT "封面",
  `summary` varchar(65533) NULL COMMENT "简介",
  `book_code` varchar(100) NULL COMMENT "代号",
  `coin_amount` int(11) NULL COMMENT "阅币消耗",
  `view_count` int(11) NULL COMMENT "观看人数",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `sort_num`)
COMMENT "每月消耗前6书籍（参考作品每月自动化更新）"
DISTRIBUTED BY HASH(`dt`, `sort_num`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);