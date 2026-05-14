CREATE TABLE `ods_tidb_short_video_log_firefly_income_report` (
  `id` bigint(20) NOT NULL COMMENT "主键ID",
  `day` bigint(20) NULL COMMENT "日期",
  `ecpm` decimal(18, 2) NULL COMMENT "广告ECPM, USO",
  `income` decimal(18, 2) NULL COMMENT "预估收益",
  `page_view` int(11) NULL COMMENT "PV",
  `task_id` varchar(1000) NULL COMMENT "任务ID",
  `task_name` varchar(1000) NULL COMMENT "任务名称",
  `system_type` int(11) NULL COMMENT "1短剧 2阅读",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "Firefly收益报告"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
