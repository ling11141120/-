CREATE TABLE `ads_bi_original_user_book_consume_ed` (
  `dt` date NOT NULL COMMENT "日期",
  `site_id` int(11) NOT NULL COMMENT "",
  `book_nature` int(11) NOT NULL COMMENT "书籍类型 3:原创 5:原创拆章",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `types` int(11) NOT NULL COMMENT "1:阅币 2：礼券 3：赠送币 4：vip 5：合计",
  `amount` decimal(18, 6) NULL COMMENT "",
  `etl_time` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `book_nature`, `book_id`, `user_id`, `types`)
COMMENT "服务端编辑后台-按天、书、用户 原创、原创拆章书籍消耗表"
DISTRIBUTED BY HASH(`dt`, `site_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);