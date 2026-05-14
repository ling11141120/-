CREATE TABLE `ods_tidb_short_video_push_center_push_position_user_log` (
  `id` bigint(20) NOT NULL COMMENT "",
  `postion_id` bigint(20) NULL COMMENT "push策略id",
  `count` bigint(20) NULL COMMENT "应处理用户人数",
  `create_time` datetime NULL COMMENT "",
  `update_time` datetime NULL COMMENT "",
  `cost` bigint(20) NULL COMMENT "耗时",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "push"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
