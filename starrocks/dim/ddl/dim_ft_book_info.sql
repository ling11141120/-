CREATE TABLE `dim_ft_book_info` (
  `dt` date NULL COMMENT "统计日期",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `book_name` varchar(65533) NULL COMMENT "书名",
  `book_code` varchar(65533) NULL COMMENT "书籍代号",
  `app_chapter` int(11) NULL COMMENT "app当前已发布章节数",
  `app_font_length` int(11) NULL COMMENT "app当前已发布字数",
  `sub_dt` date NULL COMMENT "内容提交日期",
  `sub_chapter` int(11) NULL COMMENT "提交章节数",
  `sub_total_chapter` int(11) NULL COMMENT "总提交章节数",
  `sub_font_length` int(11) NULL COMMENT "提交字数",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `book_id`)
COMMENT "446，449新掌中，090凤鸣轩书籍"
DISTRIBUTED BY HASH(`dt`, `book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, sub_dt, book_code",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);