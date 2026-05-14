CREATE TABLE `dws_report_author_translate_wow_dt_tmp_ew` (
  `To_Language` bigint(20) NULL COMMENT "",
  `week_id` bigint(20) NULL COMMENT "",
  `font_length_before_cnt` bigint(20) NULL COMMENT "",
  `font_length_now_cnt` bigint(20) NULL COMMENT "",
  `Font_Length_year_cnt` bigint(20) NULL COMMENT "",
  `before_4week_flag` varchar(1048576) NULL COMMENT "",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
DUPLICATE KEY(`To_Language`, `week_id`, `font_length_before_cnt`)
DISTRIBUTED BY HASH(`week_id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
