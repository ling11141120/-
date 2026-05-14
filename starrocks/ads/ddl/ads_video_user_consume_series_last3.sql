CREATE TABLE `ads_video_user_consume_series_last3` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户Id",
  `series_arr` varchar(500) NOT NULL COMMENT "剧Id",
  `remaining_epis_arr` varchar(500) NOT NULL COMMENT "剩余剧集",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "海剧-用户消费最后三条剧集"
DISTRIBUTED BY HASH(`product_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "product_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);