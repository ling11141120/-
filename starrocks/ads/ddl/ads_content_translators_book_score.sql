CREATE TABLE `ads_content_translators_book_score` (
  `site_id` int(11) NOT NULL COMMENT "语言id",
  `translator_id` bigint(20) NOT NULL COMMENT "译员Id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `chapter_id` int(11) NOT NULL COMMENT "章节id",
  `translator_name` varchar(200) NOT NULL COMMENT "译员姓名",
  `book_name` varchar(500) NULL COMMENT "书籍名称",
  `chapter_name` varchar(500) NULL COMMENT "章节名称",
  `check_user_id` bigint(20) NULL COMMENT "抽查人Id",
  `check_user_name` varchar(200) NULL COMMENT "抽查人姓名",
  `check_date` date NULL COMMENT "抽查完成时间(天)",
  `check_date_time` datetime NULL COMMENT "抽查完成时间(秒)",
  `check_correct_rate` decimal(10, 4) NULL COMMENT "人工抽查文本正确率",
  `score` decimal(19, 2) NULL COMMENT "人工打分",
  `new_score` decimal(19, 2) NULL COMMENT "新版得分",
  `etl_date` datetime NULL COMMENT "数据生成时间"
) ENGINE=OLAP 
PRIMARY KEY(`site_id`, `translator_id`, `book_id`, `chapter_id`)
COMMENT "内容域--翻译书籍章节打分"
DISTRIBUTED BY HASH(`site_id`, `translator_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "site_id, book_id, chapter_id, translator_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);