CREATE TABLE `ads_sv_finance_series_consume_info_d` (
  `dt` date NOT NULL COMMENT "日期",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `series_name` varchar(255) NULL COMMENT "短剧名称",
  `amount` decimal(12, 2) NULL COMMENT "花费金额",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`)
COMMENT "财务-短剧消耗明细-日期"
DISTRIBUTED BY HASH(`dt`, `series_id`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);