CREATE TABLE `ads_sr_automation_new_book_ranking_est` (
  `dt` date NOT NULL COMMENT "按天统计时间分区，西五区",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `lang_id` int(11) NOT NULL COMMENT "语言id",
  `reader_num` int(11) NULL COMMENT "阅读人数",
  `consume_num` int(11) NULL COMMENT "阅币消耗",
  `exposure_num` int(11) NULL COMMENT "小说曝光事件中的曝光用户数",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`, `lang_id`)
COMMENT "海阅-新书自动爬榜"
DISTRIBUTED BY HASH(`dt`, `book_id`, `lang_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);