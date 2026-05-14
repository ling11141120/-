CREATE TABLE `dwd_sv_user_core_attribution` (
  `user_id` varchar(255) NOT NULL COMMENT "用户id",
  `core` int(11) NOT NULL COMMENT "corever",
  `test_flag` int(11) NOT NULL COMMENT "是否为测试账号（0：正常账号、1：测试账号）",
  `start_time` datetime NOT NULL COMMENT "开始时间",
  `end_time` datetime NOT NULL COMMENT "结束时间",
  `etl_time` datetime NOT NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `core`, `test_flag`, `start_time`)
COMMENT "海剧-用户core的归因时间（只有有充值记录的用户）"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);