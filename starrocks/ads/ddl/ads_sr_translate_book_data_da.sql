CREATE TABLE `ads_sr_translate_book_data_da` (
  `dt` date NOT NULL COMMENT "日期",
  `book_id` bigint(20) NOT NULL COMMENT "目标书ID",
  `book_language_id` int(11) NOT NULL COMMENT "语言id",
  `income_last_7d_30d` decimal(16, 4) NULL COMMENT "7天折30天收入",
  `chapters_l20_publish_l7d` decimal(16, 4) NULL COMMENT "最新20章-D7收入(发布时间)",
  `plevel` varchar(100) NULL COMMENT "书籍P级",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`, `book_language_id`)
COMMENT "翻译书籍收入、消耗、等级数据信息"
DISTRIBUTED BY HASH(`dt`, `book_id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"compression" = "LZ4"
);