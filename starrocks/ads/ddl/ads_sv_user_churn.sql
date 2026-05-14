CREATE TABLE `ads_sv_user_churn` (
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `last_active_time` bigint(20) NULL COMMENT "最后活跃时间",
  `status` int(11) NULL COMMENT "默认为0，0未执行，1已执行",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`)
COMMENT "海剧-海剧流失用户表"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);