CREATE TABLE `dim_book_free_chapter_num_temp` (
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `free_chapter_num` int(11) NULL COMMENT "免费章节数",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`book_id`)
COMMENT "阅读-书籍免费章节数临时表"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);