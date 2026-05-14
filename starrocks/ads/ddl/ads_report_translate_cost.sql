CREATE TABLE `ads_report_translate_cost` (
  `dt` date NOT NULL COMMENT "时间",
  `to_language` bigint(20) NOT NULL COMMENT "语言",
  `font_inc_day1` bigint(20) NULL COMMENT "质检字数较昨日增长",
  `font_inc_week1` bigint(20) NULL COMMENT "质检字数较上周增长 固定两周内的比较",
  `font_length_month_sum1` bigint(20) NULL COMMENT "质检字数月度产能",
  `font_inc_day2` bigint(20) NULL COMMENT "一校字数较昨日增长",
  `font_inc_week2` bigint(20) NULL COMMENT "一校字数较上周增长 固定两周内的比较",
  `font_length_month_sum2` bigint(20) NULL COMMENT "一校字数月度产能",
  `font_inc_day3` bigint(20) NULL COMMENT "精修(二校)字数较昨日增长",
  `font_inc_week3` bigint(20) NULL COMMENT "精修(二校)字数较上周增长",
  `font_length_month_sum3` bigint(20) NULL COMMENT "精修(二校)字数月度产能",
  `app_publish_month_cnt` bigint(20) NULL COMMENT "月度发布章节",
  `translate_book_1d_cnt` bigint(20) NULL COMMENT "在翻书本数",
  `err_chapter_cnt` bigint(20) NULL COMMENT "精修屯稿预警书本数 精修囤稿预警=∑ 章节低于15天的本数（囤稿章节/日均章节<15天=预警1本",
  `cost_book_curmon_cnt` bigint(20) NULL COMMENT "成本数本数 本月有成本的书",
  `amount_flag_cnt` bigint(20) NULL COMMENT "已回本书",
  `amount_book_curmon_cnt` bigint(20) NULL COMMENT "本月以回本的书",
  `cost_cnt_curmon_rate` decimal(10, 4) NULL COMMENT "本月 已回本占比=已回本书/有成本的书总和",
  `err_cost_amount_rate` decimal(10, 4) NULL COMMENT "90天回本预警 = 首次翻译距今超过90天本数 / 累计费率≥100%未回本本数",
  `amount_curmon` decimal(38, 2) NULL COMMENT "本月收入",
  `cost_amt_curmon` decimal(38, 2) NULL COMMENT "本月成本",
  `cost_amount_curmon_rate` decimal(10, 4) NULL COMMENT "本月总费率",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `to_language`)
COMMENT "管理视角计划进度看板"
DISTRIBUTED BY HASH(`dt`, `to_language`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);