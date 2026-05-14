CREATE TABLE `ods_tidb_ab_hj_strategy` (
  `id` bigint(20) NOT NULL COMMENT "ID",
  `strategy_id` bigint(20) NULL COMMENT "策略id",
  `strategy_name` varchar(1000) NULL COMMENT "策略名称",
  `strategy_code` varchar(1000) NULL COMMENT "策略代号",
  `type` int(11) NULL COMMENT "策略类型",
  `second_type` int(11) NULL COMMENT "策略子类型",
  `status` int(11) NULL COMMENT "状态 0关1开",
  `start_time` datetime NULL COMMENT "开始时间",
  `end_time` datetime NULL COMMENT "结束时间",
  `sync_time` datetime NULL COMMENT "同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "AB测试-海剧策略信息表"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "second_type, strategy_id, type",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
