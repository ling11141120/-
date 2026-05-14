CREATE TABLE `ods_tidb_sv_short_video_group_user_group_user_statistics_da` (
  `id` bigint(20) NOT NULL COMMENT "主键id",
  `group_id` int(11) NULL COMMENT "分组id",
  `count` int(11) NULL COMMENT "规模",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "人群包规模统计"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "group_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
