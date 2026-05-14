CREATE TABLE `dwd_sv_group_user_experiment_log` (
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `create_time` datetime NOT NULL COMMENT "创建id",
  `experiment_id` bigint(20) NOT NULL COMMENT "人群包 id",
  `scene_id` varchar(300) NOT NULL COMMENT "场景id",
  `sr_createtime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `create_time`)
COMMENT "用户出入包记录表;author:232618"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);