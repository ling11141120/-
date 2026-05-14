CREATE TABLE `dim_optimizergroups` (
  `dt` date NOT NULL COMMENT "快照日期",
  `optimizer_group_type` smallint(6) NOT NULL COMMENT "优化师组类型 0:阅读；1：海剧；2：国剧 3：含测试",
  `ads_optimizer_group` varchar(65533) NOT NULL COMMENT "优化师组",
  `ads_optimizer` varchar(65533) NOT NULL COMMENT "优化师",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `optimizer_group_type`, `ads_optimizer_group`, `ads_optimizer`)
COMMENT "优化师维度表"
DISTRIBUTED BY HASH(`dt`, `optimizer_group_type`, `ads_optimizer_group`, `ads_optimizer`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);