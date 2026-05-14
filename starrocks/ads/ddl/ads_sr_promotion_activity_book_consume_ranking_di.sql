CREATE TABLE `ads_sr_promotion_activity_book_consume_ranking_di` (
  `dt` date NOT NULL COMMENT "日期(西五区)",
  `site_id` varchar(100) NOT NULL COMMENT "语言id",
  `book_id` varchar(100) NOT NULL COMMENT "书籍ID",
  `rn` int(11) NOT NULL COMMENT "排名",
  `languageid` int(11) NULL COMMENT "语言",
  `amount` int(11) NULL COMMENT "消耗数量",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `book_id`, `rn`)
COMMENT "海阅-折扣活动书籍书近14天各语言消耗排行"
DISTRIBUTED BY HASH(`site_id`, `book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);