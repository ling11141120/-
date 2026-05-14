CREATE TABLE `ods_tidb_short_video_online_earn` (
  `id` bigint(20) NOT NULL COMMENT "主键",
  `account_id` bigint(20) NOT NULL COMMENT "用户id",
  `value` decimal(18, 4) NULL COMMENT "网赚金数量（最多4位小数）",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `expire_time` datetime NULL COMMENT "过期时间",
  `source` int(11) NULL COMMENT "网赚金来源：1福利中心任务",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`, `account_id`)
COMMENT "海剧-网赚金"
DISTRIBUTED BY HASH(`id`, `account_id`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "account_id, create_time, expire_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
