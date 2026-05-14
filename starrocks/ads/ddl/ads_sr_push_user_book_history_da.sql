CREATE TABLE `ads_sr_push_user_book_history_da` (
  `product_id` int(11) NOT NULL COMMENT "用户id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `buy_book` varchar(1048576) NULL COMMENT "购买过的书籍",
  `bookshelf_book` varchar(1048576) NULL COMMENT "加入过书架的书籍",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "海阅PUSH，用户书籍行为"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);