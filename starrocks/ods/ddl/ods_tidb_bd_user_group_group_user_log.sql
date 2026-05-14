CREATE TABLE `ods_tidb_bd_user_group_group_user_log` (
  `dt` date NOT NULL COMMENT "日期",
  `id` bigint(20) NOT NULL COMMENT "id",
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "统计日期",
  `group_id` int(11) NOT NULL COMMENT "分群id",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `id`, `create_time`)
COMMENT "分群用户"
DISTRIBUTED BY HASH(`dt`, `id`) BUCKETS 100 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
