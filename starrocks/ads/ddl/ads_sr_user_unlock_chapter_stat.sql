CREATE TABLE `ads_sr_user_unlock_chapter_stat` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `total_unlock_chapter_count` bigint(20) NULL COMMENT "累计总解锁章节数",
  `latest_unlock_book_info` varchar(65536) NULL COMMENT "最近解锁的3本书籍中解锁章节最多的书籍类型 json字符串",
  `etl_tm` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "阅读线-用户最近解锁3本书-解锁章节数-应用于人群包标签"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id, product_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);