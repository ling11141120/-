CREATE TABLE `dws_read_user_read_book_ed_tmp` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户ID",
  `total_read_bookids` bitmap NULL COMMENT "用户阅读的书籍",
  `total_read_chp_ids` bitmap NULL COMMENT "用户阅读的书本数量",
  `total_read_days` bigint(20) NULL COMMENT "阅读天数",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "用户阅读按天汇总临时表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
