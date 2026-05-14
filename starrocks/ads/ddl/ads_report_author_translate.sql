CREATE TABLE `ads_report_author_translate` (
  `dt` date NOT NULL COMMENT "日期",
  `to_language` bigint(20) NOT NULL COMMENT "目标语言id",
  `week_id` bigint(20) NOT NULL COMMENT "周id 周五到周四  202301",
  `grade_type` int(11) NOT NULL COMMENT "档位 0-S,1-A/,2-B/,3-C,4-D",
  `capacity_target` int(11) NULL COMMENT "产能目标(字数万) ",
  `font_length_sum` decimal(10, 4) NULL COMMENT "当月截止今天产能(字数万)",
  `Capacity_Target_rate` decimal(10, 4) NULL COMMENT "达成率 font_length_sum/capacity_target",
  `spi_rate` decimal(10, 4) NULL COMMENT "达成率/时间进度",
  `font_length_year_cnt` bigint(20) NULL COMMENT "当年每周的产能",
  `font_length_before_cnt` bigint(20) NULL COMMENT "当前4周的每周产能",
  `font_length_now_cnt` bigint(20) NULL COMMENT "本周产能",
  `wow_rate` decimal(10, 4) NULL COMMENT "WOW 本周的前n天/上周的前n天",
  `before_4week_flag` varchar(20) NULL COMMENT "是否是当前4周",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `to_language`, `week_id`, `grade_type`)
COMMENT "二校产能表"
DISTRIBUTED BY HASH(`dt`, `to_language`, `week_id`, `grade_type`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);