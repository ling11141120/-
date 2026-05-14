CREATE TABLE `ads_audit_book_sc_info` (
  `language` varchar(500) NOT NULL COMMENT "书籍语言",
  `book_id` varchar(500) NOT NULL COMMENT "书籍ID",
  `book_name` varchar(500) NULL COMMENT "书籍名称",
  `source_book_name` varchar(500) NULL COMMENT "源书名称",
  `source_book_language` varchar(500) NULL COMMENT "源书籍语言",
  `dept_label` varchar(500) NULL COMMENT "归属部门标签",
  `source` varchar(500) NULL COMMENT "来源",
  `all_chapters` int(11) NULL COMMENT "书籍总章节数",
  `all_words` int(11) NULL COMMENT "书籍总字数",
  `free_chapters` int(11) NULL COMMENT "书籍免费章节数",
  `free_words` int(11) NULL COMMENT "书籍免费字数",
  `last_chapters` int(11) NULL COMMENT "书籍已发布章节数",
  `last_words` int(11) NULL COMMENT "书籍已发布字数",
  `collab_time` datetime NULL COMMENT "合作时间",
  `publish_time` datetime NULL COMMENT "上架时间",
  `publish_status` int(11) NULL COMMENT "上架状态",
  `book_type` varchar(500) NULL COMMENT "书籍类别",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`language`, `book_id`)
COMMENT "moboreader审计书籍库（简体）"
DISTRIBUTED BY HASH(`language`, `book_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);