CREATE TABLE `ads_sv_user_device2_fill` (
  `dt` date NOT NULL COMMENT "日期",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`)
COMMENT "海剧-海剧device2历史数据补全"
DISTRIBUTED BY HASH(`dt`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);