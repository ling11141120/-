CREATE TABLE `ads_big_dipper_complement_user_id` (
  `one_id` int(11) NULL COMMENT "",
  `mp_login_id` bigint(20) NULL COMMENT "",
  `mp_device_id` varchar(255) NULL COMMENT "",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl时间"
) ENGINE=OLAP 
DUPLICATE KEY(`one_id`, `mp_login_id`, `mp_device_id`)
COMMENT "北斗oneid根据设备id补全用户id"
DISTRIBUTED BY HASH(`one_id`, `mp_login_id`, `mp_device_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);