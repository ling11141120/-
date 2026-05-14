CREATE TABLE `ads_sr_promotion_activity_toufang_book_di` (
  `dt` date NOT NULL COMMENT "日期(西五区)",
  `type` int(11) NOT NULL COMMENT "类型,1：近7天有投放，2：近6月有投放近7天无投放",
  `book_id` varchar(100) NOT NULL COMMENT "书籍ID",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `type`, `book_id`)
COMMENT "海阅-折扣活动近7天投放花费书籍"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);