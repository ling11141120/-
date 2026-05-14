CREATE TABLE `ads_sch_all_task_log` (
  `dt` date NOT NULL COMMENT "时间分区",
  `node_type` bigint(20) NOT NULL COMMENT "节点类型：0 开始节点   1 结束节点  3 已发送告警",
  `sch_process_name` varchar(128) NOT NULL COMMENT "任务流名称",
  `task_time` datetime NULL COMMENT "数据生成时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `node_type`, `sch_process_name`)
COMMENT "海豚调度--sch_all调度的开始时间与结束时间-- 此表不能删除"
DISTRIBUTED BY HASH(`dt`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);