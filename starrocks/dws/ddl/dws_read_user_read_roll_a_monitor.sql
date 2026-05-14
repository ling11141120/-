CREATE TABLE `dws_read_user_read_roll_a_monitor` (
  `dt` date NOT NULL COMMENT "统计日期",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `total_read_bookids` bitmap NULL COMMENT "累计阅读书籍id",
  `total_read_chp_ids` bitmap NULL COMMENT "累计阅读章节id",
  `total_read_days` int(11) NULL COMMENT "累计阅读天数",
  `new_bookid_chapid` array<varchar(65533)> NULL COMMENT "阅读到了最新章节的章节id",
  `new_chp_book_cnt` int(11) NULL COMMENT "阅读到了最新章节的书本数",
  `etl_time` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`, `product_id`)
COMMENT "用户阅读指标表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
