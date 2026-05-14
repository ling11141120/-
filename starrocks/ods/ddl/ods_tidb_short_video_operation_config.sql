CREATE TABLE `ods_tidb_short_video_operation_config` (
  `id` bigint(20) NOT NULL COMMENT "主键",
  `key` varchar(200) NOT NULL COMMENT "key",
  `type` int(11) NULL COMMENT "类型",
  `remark` varchar(65533) NOT NULL COMMENT "描述",
  `mt` varchar(500) NULL COMMENT "平台  1 ios，4 android",
  `lang_ids` varchar(1000) NULL COMMENT "语言id数组 逗号隔开",
  `core` varchar(20) NULL COMMENT "Core (1core1，2core2，3core3，4core4)",
  `value` varchar(65533) NULL COMMENT "配置值",
  `value_type` int(11) NULL COMMENT "值类型 1字符串 2数字（后台输入校验用）",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `status` tinyint(4) NOT NULL COMMENT "启用状态0关1开",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "业务配置表"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"compression" = "LZ4"
);
