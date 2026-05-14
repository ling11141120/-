CREATE TABLE `dws_content_book_chapter_length` (
  `dt` date NOT NULL COMMENT "统计日期",
  `site_id` int(11) NOT NULL COMMENT "区分多语言",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `chapter_length_1d` int(11) NULL COMMENT "近1日章节更新字数",
  `chapter_length_7d` int(11) NULL COMMENT "近7日章节更新字数",
  `chapter_length_30d` int(11) NULL COMMENT "近30日章节更新字数",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_book_id (`book_id`) USING BITMAP COMMENT 'index_book_id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `book_id`)
COMMENT "书籍更新字数表"
DISTRIBUTED BY HASH(`book_id`, `site_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "site_id, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
