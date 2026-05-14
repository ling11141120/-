CREATE TABLE `ads_offline_label_user_firstday_readtime_mid` (
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户ID",
  `start_day_read_time` bigint(20) NULL COMMENT "首日阅读书籍章节序列",
  `etl_time` datetime NULL COMMENT "数据处理时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "离线标签用户首日阅读时长中间表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"in_memory" = "true",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);