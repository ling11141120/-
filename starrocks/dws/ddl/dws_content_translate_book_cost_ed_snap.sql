CREATE TABLE `dws_content_translate_book_cost_ed_snap` (
  `dt` date NOT NULL COMMENT "日期",
  `book_id` bigint(20) NOT NULL COMMENT "目标书籍id",
  `book_name` varchar(65533) NULL COMMENT "书籍名称",
  `site_id` smallint(6) NULL COMMENT "语言id",
  `author_name` varchar(65533) NULL COMMENT "作者名称",
  `book_cost` decimal(24, 8) NULL COMMENT "书籍成本（美金）",
  `toufang_cost` decimal(24, 8) NULL COMMENT "投放成本（美金）",
  `toufang_cost_rmb` decimal(24, 8) NULL COMMENT "投放成本（人民币）",
  `translate_cost` decimal(24, 8) NULL COMMENT "翻译成本（美金）",
  `translate_cost_rmb` decimal(24, 8) NULL COMMENT "翻译成本(人民币)",
  `proofread_length_today` bigint(20) NULL COMMENT "当日翻译字数",
  `price` decimal(24, 8) NULL COMMENT "千字稿酬价格",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`)
COMMENT "海外阅读内容域投放翻译成本1日汇总表"
DISTRIBUTED BY HASH(`dt`, `book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
