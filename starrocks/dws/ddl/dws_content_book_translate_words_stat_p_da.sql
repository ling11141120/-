CREATE TABLE `dws_content_book_translate_words_stat_p_da` (
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `site_id` int(11) NULL COMMENT "区分多语言",
  `book_code` varchar(250) NULL COMMENT "书籍代号",
  `book_name` varchar(250) NULL COMMENT "书籍名称",
  `cn_book_name` varchar(250) NULL COMMENT "中文书籍名称",
  `publish_words` varchar(250) NULL COMMENT "发布字数",
  `published_5w_date` date NULL COMMENT "发布5W字数日期",
  `published_10w_date` date NULL COMMENT "发布10W字数日期",
  `published_15w_date` date NULL COMMENT "发布15W字数日期",
  `published_20w_date` date NULL COMMENT "发布20W字数日期",
  `published_25w_date` date NULL COMMENT "发布25W字数日期",
  `published_30w_date` date NULL COMMENT "发布30W字数日期",
  `published_35w_date` date NULL COMMENT "发布35W字数日期",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`book_id`)
COMMENT "内容域--多语言书籍翻译字数统计"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
