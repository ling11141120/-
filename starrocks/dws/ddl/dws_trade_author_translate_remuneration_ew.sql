CREATE TABLE `dws_trade_author_translate_remuneration_ew` (
  `dt` date NOT NULL COMMENT "日期",
  `to_language` bigint(20) NOT NULL COMMENT "目标语言id",
  `book_id` bigint(20) NOT NULL COMMENT "输出书籍Id",
  `week_id` int(11) NOT NULL COMMENT "周(202301,周五~周四为一周)",
  `author_id` bigint(20) NOT NULL COMMENT "译员Id",
  `book_name` varchar(65533) NULL COMMENT "输出书籍名称",
  `font_length_sum` bigint(20) NULL COMMENT "字数",
  `total_price_sum` decimal(18, 4) NULL COMMENT "稿酬金额",
  `year_month_str` varchar(50) NULL COMMENT "月份(yyyy-mm)",
  `admin_Name` varchar(500) NULL COMMENT "用户名",
  `day_target` int(11) NULL COMMENT "日目标",
  `month_target` int(11) NULL COMMENT "月目标",
  `author_name` varchar(500) NULL COMMENT "译员名称",
  `workday_month_pass` bigint(20) NULL COMMENT "dt 当前月已经过的天数",
  `workday_month` bigint(20) NULL COMMENT "dt 当前月工作日天数",
  `year_month_id` int(11) NULL COMMENT "月id 202312",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `to_language`, `book_id`, `week_id`, `author_id`)
COMMENT "实时稿酬译员目标表"
DISTRIBUTED BY HASH(`dt`, `to_language`, `book_id`, `week_id`, `author_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, book_id, author_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
