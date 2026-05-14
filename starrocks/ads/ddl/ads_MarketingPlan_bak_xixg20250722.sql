CREATE TABLE `ads_MarketingPlan_bak_xixg20250722` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `book_id` varchar(128) NOT NULL COMMENT "书籍ID",
  `book_code` varchar(128) NULL COMMENT "书籍编码",
  `book_code_xl` varchar(128) NULL COMMENT "书籍编码系列",
  `current_language` varchar(128) NOT NULL COMMENT "投放语言",
  `source_chl` varchar(128) NULL COMMENT "媒体",
  `test_status` int(11) NULL DEFAULT "0" COMMENT "测试状态 0=未开始|1=测试中|2=已结束 3=停投  -1表示null或者空串",
  `code_lv` varchar(20) NULL COMMENT "最高阶段投放等级 A|S|SS",
  `code_stage` int(11) NULL COMMENT "测试阶段 海阅最大3阶 海剧最大2阶 国剧就1阶  1:第一阶段  2：第二阶段 3：第三阶段 -1：禁投 ",
  `plan_round` int(11) NOT NULL COMMENT "测试轮次1|2|3",
  `begin_date` datetime NOT NULL COMMENT "开始日期",
  `end_date` datetime NOT NULL COMMENT "结束日期",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "市场测推表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);