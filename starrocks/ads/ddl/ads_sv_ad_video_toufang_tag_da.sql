CREATE TABLE `ads_sv_ad_video_toufang_tag_da` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `book_id` bigint(20) NOT NULL COMMENT "短剧id",
  `day0_amount` decimal(16, 4) NULL COMMENT "D0收入",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `book_id`)
COMMENT "海剧近7天投放短剧标签"
DISTRIBUTED BY HASH(`product_id`, `book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);