CREATE TABLE `dws_trade_author_translateremuneration_dt_w` (
  `to_language` bigint(20) NULL COMMENT "",
  `book_id` bigint(20) NULL COMMENT "",
  `book_name` varchar(65533) NULL COMMENT "",
  `font_length_sum` bigint(20) NULL COMMENT "",
  `total_price_sum` decimal(38, 4) NULL COMMENT "",
  `year_month_str` varchar(50) NULL COMMENT "",
  `admin_name` varchar(500) NULL COMMENT "",
  `day_target` int(11) NULL COMMENT "",
  `month_target` int(11) NULL COMMENT "",
  `week_id` bigint(20) NULL COMMENT "",
  `author_id` bigint(20) NULL COMMENT "",
  `author_name` varchar(500) NULL COMMENT "",
  `workday_month_pass` bigint(20) NULL COMMENT "",
  `workday_month` bigint(20) NULL COMMENT "",
  `year_month_id` int(11) NULL COMMENT "",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
DUPLICATE KEY(`to_language`, `book_id`, `book_name`)
DISTRIBUTED BY HASH(`to_language`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
