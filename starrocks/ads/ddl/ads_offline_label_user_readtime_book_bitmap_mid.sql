CREATE TABLE `ads_offline_label_user_readtime_book_bitmap_mid` (
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户ID",
  `more_onem_total_read_bookid_bitmap` bitmap NULL COMMENT "书籍idbitmap序列",
  `etl_time` datetime NULL COMMENT "数据处理时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "离线标签用户阅读时长达标（>60s）书籍id汇总中间表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 25 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"in_memory" = "true",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);