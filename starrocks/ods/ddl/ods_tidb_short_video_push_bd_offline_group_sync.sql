CREATE TABLE `ods_tidb_short_video_push_bd_offline_group_sync` (
  `id` bigint(20) NOT NULL COMMENT "",
  `group_id` int(11) NULL COMMENT "人群包id",
  `count` bigint(20) NULL COMMENT "人数",
  `create_time` datetime NULL COMMENT "",
  `update_time` datetime NULL COMMENT "",
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
