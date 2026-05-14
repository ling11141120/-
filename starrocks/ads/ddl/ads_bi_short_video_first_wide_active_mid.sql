CREATE TABLE `ads_bi_short_video_first_wide_active_mid` (
  `product_id` bigint(20) NULL COMMENT "产品id",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `fst_active_dt` date MIN NULL COMMENT "首次活跃日期",
  `etl_time` datetime MIN NULL COMMENT "处理时间"
) ENGINE=OLAP 
AGGREGATE KEY(`product_id`, `user_id`)
COMMENT "首次活跃日期"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);