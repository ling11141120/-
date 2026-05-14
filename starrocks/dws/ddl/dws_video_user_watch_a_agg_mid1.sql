CREATE TABLE `dws_video_user_watch_a_agg_mid1` (
  `product_id` bigint(20) NULL COMMENT "产品id",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `series_id` bigint(20) NULL COMMENT "剧id",
  `epis_num` bigint(20) MAX NULL COMMENT "集数",
  `etl_time` datetime MAX NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
AGGREGATE KEY(`product_id`, `user_id`, `series_id`)
COMMENT "观看域短剧用户观看最大集数"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
