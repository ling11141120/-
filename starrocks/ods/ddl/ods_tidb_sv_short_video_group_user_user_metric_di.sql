CREATE TABLE `ods_tidb_sv_short_video_group_user_user_metric_di` (
  `id` bigint(20) NOT NULL COMMENT "唯一ID",
  `project` varchar(65533) NULL COMMENT "应用/项目名称",
  `account` varchar(65533) NULL COMMENT "用户账号",
  `user_metric_json` varchar(1048576) NULL COMMENT "用户指标JSON",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "修改时间",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "用户指标表"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "create_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
