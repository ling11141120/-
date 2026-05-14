CREATE TABLE `ads_sv_advance_streaming_consume_ed` (
  `dt` date NOT NULL COMMENT "日期（西五区时区）",
  `series_id` varchar(128) NOT NULL COMMENT "代号ProjectCode为1=书籍ID|ProjectCode为2=短剧ID",
  `spend` decimal(12, 2) NULL COMMENT "广告投放花费金额",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`)
COMMENT "海剧-超前点播章节策略自动化-书/剧每日消耗表"
DISTRIBUTED BY HASH(`dt`, `series_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);