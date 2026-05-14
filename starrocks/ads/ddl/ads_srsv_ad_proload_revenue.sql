CREATE TABLE `ads_srsv_ad_proload_revenue` (
  `product_id` bigint(20) NOT NULL COMMENT "项目id",
  `user_id` bigint(20) NOT NULL COMMENT "账户id",
  `value_micros` double NULL COMMENT "值",
  `create_time` datetime NOT NULL COMMENT "创建时间",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "海剧海阅广告预加载事件上报表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);