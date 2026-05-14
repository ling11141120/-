CREATE TABLE `ads_content_author_book_capacity_stat_di_bak_xixg20250811` (
  `md5_key` varchar(65533) NOT NULL COMMENT "md5_key唯一值",
  `dt` date NOT NULL COMMENT "日期",
  `author_id` varchar(65533) NOT NULL COMMENT "译员Id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍Id",
  `language_id` int(11) NOT NULL COMMENT "目标语言",
  `type_id` int(11) NOT NULL COMMENT "类型: 1 短剧翻译（取字数）  2 短剧审核抽查&初译审核（取字数）  3 测试稿审核（取数据条数）  4 素材翻译（取字数）  5 词条翻译（取完成字数）",
  `pen_name` varchar(200) NULL COMMENT "译名",
  `real_name` varchar(200) NULL COMMENT "姓名",
  `book_name` varchar(500) NULL COMMENT "书名",
  `capacity_value` decimal(20, 2) NULL COMMENT "产能",
  `etl_time` datetime NULL COMMENT "数据生成时间"
) ENGINE=OLAP 
PRIMARY KEY(`md5_key`)
COMMENT "内容域--译员书籍语言--按天统计字数"
DISTRIBUTED BY HASH(`md5_key`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, type_id, book_id, language_id, author_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);