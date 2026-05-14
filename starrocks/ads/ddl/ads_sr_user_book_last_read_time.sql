CREATE TABLE `ads_sr_user_book_last_read_time` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `language_id` int(11) NULL COMMENT "语言id",
  `chapter_id` bigint(20) NULL COMMENT "章节id",
  `serial_number` int(11) NULL COMMENT "章节序号",
  `last_read_time` datetime NULL COMMENT "最后阅读时间",
  `app_id` int(11) NULL COMMENT "项目id，core，语言",
  `next_chapter_id` bigint(20) NULL COMMENT "下一章id",
  `next_chapter_name` varchar(255) NULL COMMENT "下一章名称",
  `dt` date NULL COMMENT "用户活跃日期",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`, `book_id`)
COMMENT "海阅-用户书架每本书最后一次阅读时间"
DISTRIBUTED BY HASH(`user_id`, `book_id`) BUCKETS 500 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);