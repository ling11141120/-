CREATE TABLE `dws_read_user_read_newchapter_tmp` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户ID",
  `new_bookid_chapid` array<varchar(65533)> NULL COMMENT "用户阅读的最新章节",
  `new_chp_book_cnt` bigint(20) NULL COMMENT "用户阅读到最新章节的书本数量",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "用户阅读最新章节临时表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
