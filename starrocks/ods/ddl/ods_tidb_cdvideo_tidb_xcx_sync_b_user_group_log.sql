CREATE TABLE `ods_tidb_cdvideo_tidb_xcx_sync_b_user_group_log` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `_id` varchar(100) NOT NULL COMMENT "用户组ID",
  `user_id` varchar(100) NOT NULL COMMENT "用户id",
  `group_id` bigint(20) NULL COMMENT "分组ID",
  `sub_group_id` bigint(20) NULL COMMENT "人群包分组id",
  `calc_time` int(11) NULL COMMENT "跑包时间，毫秒",
  `type_info` varchar(100) NULL COMMENT "日志类型：add、remove、update、error、user_update_stats",
  `error_info` varchar(65533) NULL COMMENT "运行异常对象",
  `desc_info` varchar(65533) NULL COMMENT "描述",
  `create_time` datetime NOT NULL COMMENT "添加时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index__id (`_id`) USING BITMAP COMMENT 'index_id',
  INDEX index_group_id (`group_id`) USING BITMAP COMMENT 'index_group_id'
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "人群包日志表（出入包、包更新、运行异常等），author:510161"
DISTRIBUTED BY HASH(`Id`) BUCKETS 35 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
