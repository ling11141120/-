CREATE TABLE `ods_tidb_short_video_group_user_group_user_new` (
  `id` bigint(20) NOT NULL COMMENT "id",
  `group_id` int(11) NOT NULL COMMENT "人群包 id",
  `account` varchar(65533) NOT NULL COMMENT "账号",
  `end_ts` bigint(20) NOT NULL COMMENT "用户出包的时间戳",
  `seq_num` int(11) NULL COMMENT "账号在人群包内的序号",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`, `group_id`)
COMMENT "海外短剧人群包用户表"
DISTRIBUTED BY HASH(`id`, `group_id`) BUCKETS 650 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "group_id, id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
