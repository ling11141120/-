CREATE TABLE `ads_report_sv_AB_experiment_mul_group_tmp` (
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `group_ids` array<varchar(65533)> NULL COMMENT "人群包id",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "海剧-算法ab实验人群包表"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);